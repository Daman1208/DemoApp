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
    return ["How are you??", "Today is \(Date().customFormattedDate)", "You are looking good today!!", "You are smart!", "Stay positive"]
}

class Chat: Object {

    dynamic var message = ""
    dynamic var type = ""
    dynamic var createdAt = Date()
    dynamic var isBot = false
    
    class func getRandomResponse() -> Chat{
        let index = Int(arc4random_uniform(UInt32(sampleMessages.count)))
        let message =  sampleMessages[index]
        let response = Chat.getBotChatTemplate()
        response.message = message
        return response
    }
    
    class func getBotChatTemplate() -> Chat{
        let response = Chat()
        response.createdAt = Date()
        response.isBot = true
        response.type = ChatType.Text.rawValue
        return response
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
