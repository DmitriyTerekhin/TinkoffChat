//
//  FetchRequestService.swift
//  TinkoffChat
//
//  Created by Дмитрий Терехин on 4/19/18.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import Foundation
import CoreData

protocol IFetchRequestService {
    func getConversationWith(id: String) -> NSFetchRequest<DBConversation>
    func getNotEmptyConversationsWhereUserOnline() -> NSFetchRequest<DBConversation>
    func getLastMessageFromConversationWith(_ id: String) -> NSFetchRequest<DBMessage>
    func getAllConversations() -> NSFetchRequest<DBConversation>
    func getMessagesFromConversationWith(_ id: String) -> NSFetchRequest<DBMessage>
    func getOnlineUsers() -> NSFetchRequest<DBUser>
    func getUserWith(_ id: String) -> NSFetchRequest<DBUser>
}

class FetchRequestService: IFetchRequestService {
    
    func getConversationWith(id: String) -> NSFetchRequest<DBConversation> {
        let conversationFR = DBConversation.sortedFetchRequest
        conversationFR.predicate = NSPredicate(format: "id == %@", id)
        return conversationFR
    }
    
    func getNotEmptyConversationsWhereUserOnline() -> NSFetchRequest<DBConversation> {
        let conversationFR = DBConversation.sortedFetchRequest
        let userOnlinePredicate = NSPredicate(format: "user.isOnline == %@", NSNumber(value: true))
        let messageNotEmptyPredicate = NSPredicate(format: "messages.@count > 0")
        conversationFR.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [userOnlinePredicate,messageNotEmptyPredicate])
        return conversationFR
    }
    
    func getAllConversations() -> NSFetchRequest<DBConversation> {
        let convFR = DBConversation.sortedFetchRequest
        return convFR
    }
    
    func getMessagesFromConversationWith(_ id: String) -> NSFetchRequest<DBMessage> {
        let messagesFR = DBMessage.sortedFetchRequest
        messagesFR.sortDescriptors = DBMessage.messageDateSortDescriptor
        messagesFR.predicate = NSPredicate(format: "conversation.id == %@", id)
        return messagesFR
    }
    
    func getLastMessageFromConversationWith(_ id: String) -> NSFetchRequest<DBMessage> {
        let messagesFR = DBMessage.sortedFetchRequest
        messagesFR.sortDescriptors = DBMessage.forLastMessageSortDescriptor
        messagesFR.predicate = NSPredicate(format: "conversation.id == %@", id)
        messagesFR.fetchLimit = 1
        return messagesFR
    }
    
    func getOnlineUsers() -> NSFetchRequest<DBUser> {
        let userFR = DBUser.sortedFetchRequest
        userFR.predicate = NSPredicate(format: "isOnline == %@", NSNumber(value: true))
        return userFR
    }
    
    func getUserWith(_ id: String) -> NSFetchRequest<DBUser> {
        let userFR = DBUser.sortedFetchRequest
        userFR.predicate = NSPredicate(format: "id = %@", id)
        return userFR
    }
}
