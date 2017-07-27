//
//  Chat.swift
//  TheBot
//
//  Created by Daman on 27/07/17.
//  Copyright © 2017 Tarsem. All rights reserved.
//

import UIKit
import RealmSwift

enum ChatType: String{
    case Text = "text",
    Image = "image"
}

var sampleMessages:[String]{
    return ["Hi", "How are you??"]
}

class Chat: Object {

    dynamic var message = ""
    dynamic var type = ""
    dynamic var createdAt = Date()
    dynamic var isBot = false
    
    class func randomMessage(){
        
    }
}


//
//class ChatList: Object {
//    
//    dynamic var message = ""
//    dynamic var createdAt = Date()
//    let tasks = List<Chat>()
//    
//}
