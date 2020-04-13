//
//  MessageTableViewCell.swift
//  TinkoffChat
//
//  Created by Дмитрий Терехин on 4/26/18.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell, ReusableView {
    static let xibName = "MessageTableViewCell"
    
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var bubbleView: UIView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.text = nil
    }
}
