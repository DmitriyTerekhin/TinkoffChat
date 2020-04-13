//
//  StorageManager.swift
//  TinkoffChat
//
//  Created by Dmitriy Terekhin on 04/04/2018.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import CoreData

typealias SavingMyProfileCompletionHandler = (Bool)->()

protocol IProfileStorageManager {
    func saveMyProfile(with model: AppUserModel, into context: NSManagedObjectContext, completionHandler: @escaping SavingMyProfileCompletionHandler)
    func loadMyProfile(by context: NSManagedObjectContext) -> AppUserModel?
}

protocol IUsersAndDialogsStorageManager {
    func findUserById(with context: NSManagedObjectContext, fetchRequest: NSFetchRequest<DBUser>) -> UserModel?
    func addNewUser(_ user: UserModel, into context: NSManagedObjectContext)
    func updateUserStatus(_ userRequest: NSFetchRequest<DBConversation>, isOnline: Bool, into context: NSManagedObjectContext, completionHandler: @escaping UpdatedCompletionHandler)
    func addConversationToUser(_ userRequest: NSFetchRequest<DBUser>, conversationRequest:  NSFetchRequest<DBConversation>, in context: NSManagedObjectContext)
    func addNewConversation(_ conversation: ConversationList, into context: NSManagedObjectContext, userRequest: NSFetchRequest<DBUser>)
    func saveNewMessage(in context: NSManagedObjectContext, with model: Message, with conversationFR: NSFetchRequest<DBConversation>, completionHandler: @escaping UpdatedCompletionHandler)
    func fetchLastMessage(with context: NSManagedObjectContext, fetchRequest: NSFetchRequest<DBMessage>) -> Message?
}

//Работа с диалогами и юзерами
final class StorageManager: IUsersAndDialogsStorageManager {

    static let shared = StorageManager()
    
    private init() {}
    
    func findUserById(with context: NSManagedObjectContext, fetchRequest: NSFetchRequest<DBUser>) -> UserModel? {
        guard
            let dbUsers = try? context.fetch(fetchRequest),
            let dbUser = dbUsers.first else {return nil}
        return UserModel(from: dbUser)
    }
    
    func addNewUser(_ user: UserModel, into context: NSManagedObjectContext) {
        context.performAndWait {
            _ = DBUser.insert(into: context, userModel: user)
        }
        context.performSave{}
    }
    
    func updateUserStatus(_ conversationRequest: NSFetchRequest<DBConversation>, isOnline: Bool, into context: NSManagedObjectContext, completionHandler statusUpdatedCompletionHandler: @escaping UpdatedCompletionHandler) {
        guard
            let dbConvArr = try? context.fetch(conversationRequest),
            let dbConv = dbConvArr.first
        else {return}
        
        context.performAndWait {
            dbConv.user.updateUserStatusOn(isOnline)
        }
        
        context.performSave {statusUpdatedCompletionHandler()}
    }
    
    func fetchLastMessage(with context: NSManagedObjectContext, fetchRequest: NSFetchRequest<DBMessage>) -> Message? {
        guard
            let dbMessages = try? context.fetch(fetchRequest),
            let dbMessage = dbMessages.first else {return nil}
        return Message(from: dbMessage)
    }
    
    func addConversationToUser(_ userRequest: NSFetchRequest<DBUser>, conversationRequest:  NSFetchRequest<DBConversation>, in context: NSManagedObjectContext) {
        guard let dbUsersArr = try? context.fetch(userRequest),
              let dbUser = dbUsersArr.first,
              let dbConvsArr = try? context.fetch(conversationRequest),
              let dbConversation = dbConvsArr.first
        else {return}
        dbUser.addConversation(dbConversation)
        context.performSave {}
    }
    
    func addNewConversation(_ conversation: ConversationList, into context: NSManagedObjectContext, userRequest: NSFetchRequest<DBUser>) {
        guard
            let dbUsersArr = try? context.fetch(userRequest),
            let dbUser = dbUsersArr.first
        else {return}
        context.performAndWait {
            _ = DBConversation.insert(into: context, conversationModel: conversation, user: dbUser)
        }
        context.performSave{}
    }
    
    func saveNewMessage(in context: NSManagedObjectContext, with model: Message, with conversationFR: NSFetchRequest<DBConversation>, completionHandler: @escaping UpdatedCompletionHandler) {
        do {
            if let conv = try context.fetch(conversationFR).first {
                context.performAndWait {
                    DBMessage.insert(into: context, messageModel: model, conversation: conv)
                }
                context.performSave {completionHandler()}
            } else {
                print("no conversation")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

//MARK: - Profile works
extension StorageManager: IProfileStorageManager {
    
    func saveMyProfile(with model: AppUserModel, into context: NSManagedObjectContext, completionHandler: @escaping SavingMyProfileCompletionHandler) {
        if let dbAppUser = DBAppUser.fetch(in: context).first {
            dbAppUser.updateProfileInfo(with: model)
        } else {
            _ = DBAppUser.insert(into: context, appUserModel: model)
        }
        context.performSave {
            completionHandler(true)
        }
    }
    
    func loadMyProfile(by context: NSManagedObjectContext) -> AppUserModel? {
        guard let user = DBAppUser.fetch(in: context).first else {
            return nil
        }
        return AppUserModel(from: user)
    }
}
