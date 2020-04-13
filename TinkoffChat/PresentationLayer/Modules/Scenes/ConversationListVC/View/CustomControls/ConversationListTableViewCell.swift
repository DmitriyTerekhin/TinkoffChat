//
//  ConversationListTableViewCell.swift
//  TinkoffChat
//
//  Created by Dmitriy Terekhin on 10/03/2018.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import UIKit

class ConversationListTableViewCell: UITableViewCell {
    
    static let xibName = "ConversationListTableViewCell"
    static let reuseIdentifier = "ConversationListTableViewCellReuseIdentifier"
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var lastMessageLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    let dateFormatter = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(with model: ConversationsListConfiguration) {
        
        if let name = model.name {
            nameLabel.text = name
        } else {
            nameLabel.text = "unnamed"
        }
        
        if let message = model.message {
            lastMessageLabel.text = message
        } else {
            lastMessageLabel.text = "No messages yet"
            lastMessageLabel.font = UIFont.italicSystemFont(ofSize: 17)
        }
        
        if model.hasUnreadMessage {
            lastMessageLabel.font = UIFont.boldSystemFont(ofSize: 17)
        }
        
        if model.online {
            backgroundColor = UIColor(hexString: "FFF8DC")
        } else {
            backgroundColor = .white
        }
        
        setupDate(model.date)
    }
    
    private func setupDate(_ date: Date?) {
        guard let date = date, let currentDate = getCurrentDateFromMidnight() else {timeLabel.text = "";return}
        
        if date < currentDate {
            timeLabel.text = date.string(with: "dd MMM")
        } else {
            timeLabel.text = date.string(with: "HH:mm")
        }
        
    }
    
    private func getCurrentDateFromMidnight() -> Date? {
        let calendar = Calendar.current
        
        let componentsFromToday = calendar.dateComponents([.day, .month, .year], from: Date())
        
        var components = DateComponents()
        components.day = componentsFromToday.day ?? 0
        components.month = componentsFromToday.month ?? 0
        components.year = componentsFromToday.year ?? 0
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        return calendar.date(from: components) ?? nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = .white
        lastMessageLabel.font = UIFont.systemFont(ofSize: 17)
        nameLabel.text = nil
        lastMessageLabel.text = nil
        timeLabel.text = nil
    }

}
