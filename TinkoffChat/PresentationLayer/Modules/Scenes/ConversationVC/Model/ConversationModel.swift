//
//  ConversationModel.swift
//  TinkoffChat
//
//  Created by Дмитрий Терехин on 4/26/18.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import Foundation
import CoreData

protocol IConversationModel: CommunicationDialogDelegate {
    var delegate: ConversationModelDelegate? { get set }
    func sendMessage(text: String, to: String, completionHandler: @escaping (Bool, Error?) -> ())
    func saveMessage(_ messageModel: Message, userId: String)
    func setupFRC(with userId: String)
    func getCellHeightForText(_ messageText: String) -> CGFloat
}

protocol ConversationModelDelegate: class {
    func connectionChanged(with userId: String, on: Bool)
    func setupView(with frc: NSFetchedResultsController<DBMessage>)
}

class ConversationModel: IConversationModel {
    
    let storage: IUserDialogStorageService
    let communicationService: ICommunicationService
    let frService: IFetchRequestService
    let frcService: IFetchResultControllerService
    weak var delegate: ConversationModelDelegate?
    
    init(storage: IUserDialogStorageService, communicationService: ICommunicationService, fetchRequestService: IFetchRequestService, fetchResultControllerService: IFetchResultControllerService) {
        self.storage = storage
        self.communicationService = communicationService
        self.frService = fetchRequestService
        self.frcService = fetchResultControllerService
        communicationService.dialogDelegate = self
    }
    
    func sendMessage(text: String, to: String, completionHandler: @escaping (Bool, Error?) -> ()) {
        communicationService.sendMessage(string: text, to: to, completionHandler: completionHandler)
    }
    
    func getCellHeightForText(_ messageText: String) -> CGFloat {
        let size = CGSize(width:  UIScreen.main.bounds.width * 3/4, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)], context: nil)
        return estimatedFrame.height + 28
    }
    
    func saveMessage(_ messageModel: Message, userId: String) {
        storage.saveNewMessage(messageModel: messageModel, conversationRequest: frService.getConversationWith(id: userId)) {
        }
    }
    
    func connectionChanged(with userId: String, on: Bool) {
        delegate?.connectionChanged(with: userId, on: on)
    }
    
    func didRecievedMessage(text: String, fromUser: String) {
        saveMessage(Message(isIncoming: true, text: text), userId: fromUser)
    }
    
    func setupFRC(with userId: String)  {
        let frc = frcService.configureAndGetFRC(with: frService.getMessagesFromConversationWith(userId))
        delegate?.setupView(with: frc)
    }
    
}
