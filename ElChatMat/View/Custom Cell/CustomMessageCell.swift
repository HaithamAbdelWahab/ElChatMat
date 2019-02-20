//
//  CustomMessageCell.swift
//  ElChatMat
//
//  Created by Haitham Abdel Wahab on 2/11/19.
//  Copyright © 2019 IOSDeveloper. All rights reserved.
//

import UIKit

class CustomMessageCell: UITableViewCell {
    
    
    @IBOutlet var messageBackground: UIView!
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var messageBody: UILabel!
    @IBOutlet var senderUsername: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code goes here
        
        
        
    }
    
    
}
