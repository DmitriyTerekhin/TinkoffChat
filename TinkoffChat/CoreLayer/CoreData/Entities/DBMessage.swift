//
//  DBMessage.swift
//  TinkoffChat
//
//  Created by Дмитрий Терехин on 4/19/18.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import Foundation
import CoreData

@objc(DBMessage	)
public final class DBMessage: NSManagedObject {
    
    @NSManaged public private(set) var isIncoming: Bool
    @NSManaged public private(set) var text: String?
    @NSManaged public private(set) var date: Date
    @NSManaged public private(set) var conversation: DBConversation
    
    static func insert(into context: NSManagedObjectContext, messageModel: Message, conversation: DBConversation) {
        let dbMesaage: DBMessage = context.insertObject()
        dbMesaage.isIncoming = messageModel.isIncoming
        dbMesaage.text = messageModel.text
        dbMesaage.date = messageModel.date
        dbMesaage.conversation = conversation
        conversation.updateConversation(with: dbMesaage, hasUnreadMessage: conversation.hasUnreadMessage)
    }
}

extension DBMessage: ManagedObjectType {
    public static var entityName: String {
        return "DBMessage"
    }
    
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "id", ascending: true)]
    }
    
    public static var messageDateSortDescriptor: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "date", ascending: true)]
    }
    
    public static var forLastMessageSortDescriptor: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "date", ascending: false)]
    }
    
}
