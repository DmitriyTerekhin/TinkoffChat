//
//  DBConversation.swift
//  TinkoffChat
//
//  Created by Дмитрий Терехин on 4/19/18.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import Foundation
import CoreData

@objc(DBConversation)
public final class DBConversation: NSManagedObject {
    
    @NSManaged public private(set) var hasUnreadMessage: Bool
    @NSManaged public private(set) var id: String
    @NSManaged public private(set) var appUser: DBAppUser
    @NSManaged public private(set) var messages: NSSet?
    @NSManaged public var user: DBUser
    
    static func insert(into context: NSManagedObjectContext, conversationModel: ConversationList, user: DBUser) -> DBConversation {
        let conversation: DBConversation = context.insertObject()
        conversation.hasUnreadMessage = conversationModel.hasUnreadMessage
        conversation.id = conversationModel.userId
        conversation.user = user
        return conversation
    }
    
    func updateConversation(with message: DBMessage, hasUnreadMessage: Bool) {
        if let messagesSet = messages, let messageArr = Array(messagesSet) as? [DBMessage] {
            var mesArr = messageArr
            mesArr.append(message)
            messages = NSSet(array: mesArr)
        } else {
            messages = NSSet(array: [message])
        }
        self.hasUnreadMessage = hasUnreadMessage
    }
    
}

extension DBConversation: ManagedObjectType {
    public static var entityName: String {
        return "DBConversation"
    }
    
    public static var isOnline: NSSortDescriptor {
        return NSSortDescriptor(key: "user.isOnline", ascending: true)
    }
}
