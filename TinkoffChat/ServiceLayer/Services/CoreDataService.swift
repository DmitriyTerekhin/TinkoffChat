//
//  StorageService.swift
//  TinkoffChat
//
//  Created by Дмитрий Терехин on 4/26/18.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import Foundation
import CoreData

protocol IUserDialogStorageService {
    func findUserById(_ id: String, userRequest: NSFetchRequest<DBUser>) -> UserModel?
    func addNewUser(_ user: UserModel)
    func updateUserStatus(_ conversationRequestRequest: NSFetchRequest<DBConversation>, isOnline: Bool, completionHandler: @escaping UpdatedCompletionHandler)
    func addConversationToUser(_ userRequest: NSFetchRequest<DBUser>, conversationRequest: NSFetchRequest<DBConversation>)
    func addNewConversation(conversation: ConversationList, userRequest: NSFetchRequest<DBUser>)
    func getLastMessageFrom(_ messageRequest: NSFetchRequest<DBMessage>) -> Message?
    func saveNewMessage(messageModel: Message, conversationRequest: NSFetchRequest<DBConversation>, completionHandler: @escaping UpdatedCompletionHandler)
}

typealias UpdatedCompletionHandler = () -> Void

class UserStorageService: IUserDialogStorageService {
    
    let storage: IUsersAndDialogsStorageManager
    let CDStack: ICoreDataStack
    
    init(storage: IUsersAndDialogsStorageManager, CDStack: ICoreDataStack) {
        self.storage = storage
        self.CDStack = CDStack
    }
    
    func findUserById(_ id: String, userRequest: NSFetchRequest<DBUser>) -> UserModel? {
        return storage.findUserById(with: CDStack.mainContext, fetchRequest: userRequest)
    }
    
    func addNewUser(_ user: UserModel) {
        storage.addNewUser(user, into: CDStack.saveContext)
    }
    
    func getLastMessageFrom(_ messageRequest: NSFetchRequest<DBMessage>) -> Message? {
        return storage.fetchLastMessage(with: CDStack.mainContext, fetchRequest: messageRequest)
    }
    
    func updateUserStatus(_ conversationRequest: NSFetchRequest<DBConversation>, isOnline: Bool, completionHandler: @escaping UpdatedCompletionHandler) {
        storage.updateUserStatus(conversationRequest, isOnline: isOnline, into: CDStack.mainContext, completionHandler: completionHandler)
    }
    
    func addConversationToUser(_ userRequest: NSFetchRequest<DBUser>, conversationRequest: NSFetchRequest<DBConversation>) {
        storage.addConversationToUser(userRequest, conversationRequest: conversationRequest, in: CDStack.saveContext)
    }
    
    func addNewConversation(conversation: ConversationList, userRequest: NSFetchRequest<DBUser>) {
        storage.addNewConversation(conversation, into: CDStack.saveContext, userRequest: userRequest)
    }
    
    func saveNewMessage(messageModel: Message, conversationRequest: NSFetchRequest<DBConversation>, completionHandler: @escaping UpdatedCompletionHandler) {
        storage.saveNewMessage(in: CDStack.mainContext, with: messageModel, with: conversationRequest, completionHandler: completionHandler)
    }
    
}
