//
//  ViewController.swift
//  TheBot
//
//  Created by Daman on 27/07/17.
//  Copyright © 2017 Tarsem. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: BaseViewController {

    //MARK:- Outlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var textView: UITextView!
    @IBOutlet var constTextContainerHeight: NSLayoutConstraint!
    @IBOutlet var constTextContainerBottom: NSLayoutConstraint!
    
    //MARK:- Properties
    var chatArray:Results<Chat>!
    var placeholderLabel : UILabel!
    
    //MARK:- View Hierarchy
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterKeyboardNotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:- Setup view
    
    func setupView(){
        self.navigationItem.title = "Bot Chat"
        
        super.dismissScrollViewOnTap(scrollview: tableView)
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        
        textView.delegate = self
        placeholderLabel = textView.placeholder(text:"Enter some text...")
        
        ChatCell.registerMainNibs(tableView)
        tableView.dataSource = self
        reloadChatAndUpdateUI()
        if chatArray.count == 0{
            CurrentLocation.getCurentLocation(true, completion: { (location, error) in
                if error == nil{
                    CurrentLocation.getAddressAtLocation(location!, success: { (address) in
                        if address == nil{
                            return
                        }
                        DispatchQueue.main.async{
                            self.sendLocation(address!)
                        }
                    })
                }
            })
        }
    }
    
    //MARK:- Update Chat Data

    func reloadChatAndUpdateUI(){
        chatArray = uiRealm.objects(Chat.self)
        self.tableView.reloadData()
    }
    
    //MARK:- textView Delegate

    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    //MARK:- Notifications

    func registerKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func unregisterKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self)
    }
    
    override func keyboardWillShow(notification:NSNotification){
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            // let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            self.constTextContainerBottom.constant = keyboardSize.height
            UIView.animate(withDuration: 0.25, animations: {
                self.view.layoutIfNeeded()
                self.scrollToLastCell()
            })
        }
        
    }
    
    override func keyboardWillHide(notification:NSNotification){
        self.constTextContainerBottom.constant = 0
        self.view.layoutIfNeeded()
    }

    
    func scrollToLastCell(){
        let lastRowNumber = tableView.numberOfRows(inSection: 0) - 1
        if lastRowNumber <= 0{
            return
        }
        let indexPath:IndexPath = IndexPath.init(row: lastRowNumber, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }
    
    //MARK:- SendMessage

    @IBAction func send(_ sender: Any) {
        let content = String.trim(textView.text)
        if content.isEmpty {
            return
        }
        textView.text = ""
        let chat = Chat()
        chat.message = content
        chat.isBot = false
        chat.createdAt = Date()
        chat.type = ChatType.Text.rawValue
        sendMessage([chat])
        self.perform(#selector(sendBotMessage), with: nil, afterDelay: 2)
    }
    
    func sendMessage(_ array:[Chat]){
        try! uiRealm.write{
            uiRealm.add(array)
        }
        reloadChatAndUpdateUI()
        scrollToLastCell()
    }

    func sendBotMessage(){
        sendMessage([Chat.getRandomResponse()])
    }
    
    func sendLocation(_ address: String){
        let response = Chat.getBotChatTemplate()
        response.message = "Your current location is " + address
        sendMessage([response])
    }
    
}

extension ViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chatArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chat = chatArray[indexPath.row]
        let cell = ChatCell.dequeMainCell(self.tableView, chat.type, isBot: chat.isBot, indexPath)
        cell.configureFor(chat: chat)
        return cell;
    }
}

