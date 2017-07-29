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

    //MARK:- Properties
    
    var scrollViewObj:UIScrollView?
    var currentField:UIView?
    var keyboardWillShowBlock:KeyboardWillShowBlock?
    var keyboardWillHideBlock:KeyboardWillHideBlock?

    //MARK:- View Hierarchy

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
    
    //MARK:- Dismiss Keyboard functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
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
    
    //MARK:- TextField Delegates

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

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        currentField = textField;
        return true;
    }
    
}
