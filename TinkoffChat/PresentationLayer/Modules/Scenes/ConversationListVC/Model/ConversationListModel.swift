//
//  ConversationListModel.swift
//  TinkoffChat
//
//  Created by Дмитрий Терехин on 4/26/18.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import Foundation
import CoreData

protocol IConversationListModel: CommunicationManagerDelegate{
    var delegate: ConversationListModelDelegate? { get set }
    func setupFRC()
    func getlastMessageFromConversationsWith(_ id: String) -> Message?
}

protocol ConversationListModelDelegate {
    func setupView(with frc: NSFetchedResultsController<DBConversation>)
    func updateFRC()
}

class ConversationListModel: IConversationListModel {
    
    var delegate: ConversationListModelDelegate?
    
    let storage: IUserDialogStorageService
    let communicationService: ICommunicationService
    let frService: IFetchRequestService
    let frcService: IFetchResultControllerService
    
    init(storage: IUserDialogStorageService, communicationService: ICommunicationService, fetchRequestService: IFetchRequestService, fetchResultControllerService: IFetchResultControllerService) {
        self.storage = storage
        self.communicationService = communicationService
        self.frService = fetchRequestService
        self.frcService = fetchResultControllerService
        self.communicationService.delegate = self
    }
    
    func didFoundUser(userId: String, userName: String?) {
        if self.findUserInStorageWith(userId) != nil {
            self.updateUserStatus(userId, isOnline: true)
        } else {
            self.insertNewUserAndConversation(userId: userId, userName: userName)
        }
    }
    
    func setupFRC() {
        let frc = frcService.configureAndGetFRC(with: frService.getAllConversationsWhereUserIsOnline())
        DispatchQueue.main.async {
            self.delegate?.setupView(with: frc)
        }
    }
    
    func getlastMessageFromConversationsWith(_ id: String) -> Message? {
        return storage.getLastMessageFrom(frService.getLastMessageFromConversationWith(id))
    }
    
    private func findUserInStorageWith(_ userId: String) -> UserModel? {
        return storage.findUserById(userId, userRequest: frService.getUserWith(userId))
    }
    
    private func updateUserStatus(_ userId: String, isOnline: Bool) {
        storage.updateUserStatus(frService.getConversationWith(id: userId), isOnline: isOnline) {
            DispatchQueue.main.async {
                self.delegate?.updateFRC()
            }
        }
    }
    
    private func insertNewUserAndConversation(userId: String, userName: String?) {
        let convModel = ConversationList( name: userName, userId: userId, message: nil, date: nil, online: true, hasUnreadMessage: false)
        let userModel = UserModel(id: userId, name: userName ?? "unnamed", isOnline: true)
        storage.addNewUser(userModel)
        storage.addNewConversation(conversation: convModel, userRequest: frService.getUserWith(userModel.id))
        storage.addConversationToUser(frService.getUserWith(userModel.id), conversationRequest: frService.getConversationWith(id: convModel.userId))
    }
    
    func didLostUser(userId: String) {
        DispatchQueue.main.async {
            self.updateUserStatus(userId, isOnline: false)
        }
    }
    
    func didRecieveMessage(text: String, fromUser: String, toUser: String) {
        let message = Message(isIncoming: true, text: text)
        storage.saveNewMessage(messageModel: message, conversationRequest: frService.getConversationWith(id: fromUser)) {
            DispatchQueue.main.async {
                self.delegate?.updateFRC()
            }
        }
    }
}
