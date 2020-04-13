//
//  MessageModel.swift
//  TinkoffChat
//
//  Created by Дмитрий Терехин on 3/13/18.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import Foundation

protocol MessageCellConfiguration: class {
    var text: String? {get set}
    var isIncoming: Bool {get set}
}

class Message: MessageCellConfiguration {
    
    var text: String?
    var isIncoming: Bool
    var date: Date

    init(isIncoming: Bool, text: String?) {
        self.isIncoming = isIncoming
        self.text = text
        self.date = Date()
    }
    
    init(from message: DBMessage) {
        self.date = message.date
        self.text = message.text
        self.isIncoming = message.isIncoming
    }
}
