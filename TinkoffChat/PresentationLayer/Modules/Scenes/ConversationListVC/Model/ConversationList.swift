//
//  ConversationList.swift
//  TinkoffChat
//
//  Created by Dmitriy Terekhin on 12/03/2018.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import Foundation

protocol ConversationsListConfiguration: class {
    var name: String? {get set}
    var userId: String {get set}
    var message: String? {get set}
    var date: Date? {get set}
    var online: Bool {get set}
    var hasUnreadMessage: Bool {get set}
}

struct ConversationsListSection {
    var tittle: String
    var rows: [ConversationsListConfiguration]
}

class ConversationList: ConversationsListConfiguration {
    var userId: String
    var name: String?
    var message: String?
    var date: Date?
    var online: Bool
    var hasUnreadMessage: Bool
    
    init(name: String?, userId: String, message: String?, date: Date?, online: Bool, hasUnreadMessage: Bool) {
        self.name = name
        self.message = message
        self.date = date
        self.online = online
        self.hasUnreadMessage = hasUnreadMessage
        self.userId = userId
    }
    
    convenience init(from dbConversation: DBConversation) {
        
        var message: String? = nil
        var date: Date? = nil
        
        if let messages = dbConversation.messages, let messageArr = Array(messages) as? [DBMessage] {
            message = messageArr.last?.text
            date = messageArr.last?.date
        }
        
        self.init(name: dbConversation.user.name, userId: dbConversation.user.id, message: message, date: date, online: dbConversation.user.isOnline, hasUnreadMessage: dbConversation.hasUnreadMessage)
    }
}
