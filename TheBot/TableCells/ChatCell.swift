//
//  ChatCell.swift
//  TheBot
//
//  Created by Daman on 27/07/17.
//  Copyright © 2017 Tarsem. All rights reserved.
//

import UIKit
import Kingfisher

class ChatCell: UITableViewCell {

    @IBOutlet weak var lblMessage: UILabel?
    @IBOutlet weak var lblTime: UILabel?
    @IBOutlet weak var imgMedia: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //MARK:- Configure cell data
    
    func configureFor(chat: Chat){
        if chat.type == ChatType.Image.rawValue{
            guard let image = URL.init(string: chat.message) else{
                return
            }
             imgMedia?.kf.setImage(with: ImageResource.init(downloadURL:image))
        }
        else{
            lblMessage?.text = chat.message
        }
        lblTime?.text = chat.createdAt.customFormattedTime.lowercased()
    }
}
