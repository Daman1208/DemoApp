//
//  TableCellsHandler.swift
//  TheBot
//
//  Created by Daman on 27/07/17.
//  Copyright © 2017 Tarsem. All rights reserved.
//

import UIKit

extension ChatCell{
    
    //MARK:- Register Chat Cells
    
    class func registerMainNibs(_ tableView: UITableView){
        tableView.register(UINib(nibName: "ChatTextCell", bundle: nil), forCellReuseIdentifier: "ChatTextCell")
        tableView.register(UINib(nibName: "ChatImageCell", bundle: nil), forCellReuseIdentifier: "ChatImageCell")
        tableView.register(UINib(nibName: "ChatBotTextCell", bundle: nil), forCellReuseIdentifier: "ChatBotTextCell")
        tableView.register(UINib(nibName: "ChatBotImageCell", bundle: nil), forCellReuseIdentifier: "ChatBotImageCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 335
    }
    
    //MARK:- Dequeue Chat Cells
    
    class func dequeMainCell(_ tableView: UITableView, _ type: String, isBot: Bool, _ indexPath: IndexPath) -> ChatCell{
        var ContentCellIdentifier = ""
        if type == ChatType.Image.rawValue{
            if isBot == true{
                ContentCellIdentifier = "ChatBotImageCell"
            }
            else{
                ContentCellIdentifier = "ChatImageCell"
            }
        }
        else{
            if isBot == true{
                ContentCellIdentifier = "ChatBotTextCell"
            }
            else{
                ContentCellIdentifier = "ChatTextCell"
            }
        }
        return tableView.dequeueReusableCell(withIdentifier: ContentCellIdentifier, for:indexPath) as! ChatCell
    }
}


class TableCellsHandler: NSObject {

}
