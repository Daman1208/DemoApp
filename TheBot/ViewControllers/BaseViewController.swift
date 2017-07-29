//
//  BaseViewController.swift
//  TheBot
//
//  Created by Daman on 27/07/17.
//  Copyright © 2017 Tarsem. All rights reserved.
//

import UIKit


typealias KeyboardWillShowBlock = (NSInteger) -> Void
typealias KeyboardWillHideBlock = (NSInteger) -> Void

class BaseViewController: UIViewController , UITextFieldDelegate, UITextViewDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate{

    @IBOutlet var constraintBottomLatest: NSLayoutConstraint!
    var scrollViewObj:UIScrollView?
    var currentField:UIView?
    var keyboardWillShowBlock:KeyboardWillShowBlock?
    var keyboardWillHideBlock:KeyboardWillHideBlock?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    func showBackButton(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named:"ic_back"), style: .plain, target: self, action: #selector(backTapped))
    }
    
    func backTapped(){
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func dismissScrollViewOnTap(scrollview: UIScrollView){
        scrollViewObj = scrollview
        let tapGes:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapped(ges:)))
        tapGes.cancelsTouchesInView = false
        tapGes.delegate = self
        scrollViewObj?.addGestureRecognizer(tapGes)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.classForCoder == UIButton.classForCoder() {
            return false;
        }
        return true;
    }
    
    func tapped(ges:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let tag = textField.tag;
        
        if let view = self.view.viewWithTag(tag+1), (type(of: view) == UITextField.self || type(of: view) == UITextView.self){
            view.becomeFirstResponder()
        }
        else{
           textField.resignFirstResponder()
        }
        return true;
    }

    
    func registerKeyboardNotifications(scrollview:UIScrollView){
        scrollViewObj = scrollview
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unregisterKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    
    func keyboardWillShow(notification:NSNotification){
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            self.scrollViewObj?.contentInset = contentInsets;
            self.scrollViewObj?.scrollIndicatorInsets = contentInsets;
            
            let rect:CGRect = currentField?.convert((currentField?.frame)!, to: self.view) ?? CGRect.zero
            var aRect = self.view.frame;
            aRect.size.height -= keyboardSize.height;
            if aRect.contains(rect.origin) {
                self.scrollViewObj?.scrollRectToVisible(rect, animated: true)
            }
        }
    }
    
    func keyboardWillHide(notification:NSNotification){
        let contentInsets = UIEdgeInsets.zero
        self.scrollViewObj?.contentInset = contentInsets;
        self.scrollViewObj?.scrollIndicatorInsets = contentInsets;
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        currentField = textField;
        return true;
    }
    
}
