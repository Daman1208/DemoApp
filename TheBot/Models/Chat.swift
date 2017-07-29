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
    return ["How are you??", "Today is \(Date().customFormattedDate)", "https://biosafehort.files.wordpress.com/2014/05/sweet-william-4123_640.jpg", "You are looking good today!!", "You are smart!", "http://www.ios9wallpaperhd.com/wp-content/uploads/Nature/1080/Nature%20iOS%209%20Wallpaper%20210.jpg", "Stay positive", "http://www.ios9wallpaperhd.com/wp-content/uploads/Nature/750/Nature%20iOS%209%20Wallpaper%20135.jpg", "https://s-media-cache-ak0.pinimg.com/736x/16/1c/12/161c12e9afd1bc7eda298d2074c70019--iphone-backgrounds-phone-wallpapers.jpg"]
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
        if message.hasPrefix("http"){
            response.type = ChatType.Image.rawValue
        }
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

