//
//  ConversationModel.swift
//  TinkoffChat
//
//  Created by Дмитрий Терехин on 4/26/18.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import Foundation
import CoreData

protocol IConversationPresenter: CommunicationDialogDelegate {
    var companionUserId: String { get }
    func attachView(_ view: IConversationView)
    func sendMessage(text: String, to: String)
    func saveMessage(_ messageModel: Message, userId: String)
    func setupFRC(with userId: String)
    func getCellHeightForText(_ messageText: String) -> CGFloat
}

protocol IConversationView: class {
    func connectionChanged(with userId: String, on: Bool)
    func setupView(with frc: NSFetchedResultsController<DBMessage>)
    func displayMessage(title: String, msg: String)
    func clearTextField()
}

class ConversationPresenter: IConversationPresenter {
    
    let storage: IUserDialogStorageService
    let communicationService: ICommunicationService
    let frService: IFetchRequestService
    let frcService: IFetchResultControllerService
    var companionUserId: String
    weak var view: IConversationView?
    
    init(storage: IUserDialogStorageService, communicationService: ICommunicationService, fetchRequestService: IFetchRequestService, fetchResultControllerService: IFetchResultControllerService, companionUserId: String) {
        self.companionUserId = companionUserId
        self.storage = storage
        self.communicationService = communicationService
        self.frService = fetchRequestService
        self.frcService = fetchResultControllerService
        communicationService.dialogDelegate = self
    }
    
    func attachView(_ view: IConversationView) {
        self.view = view
    }
    
    func sendMessage(text: String, to: String) {
        communicationService.sendMessage(string: text, to: to) {[weak self] (success, error) in
            DispatchQueue.main.async {
                guard let strongSelf = self else {return}
                if success {
                    strongSelf.saveMessage(Message(isIncoming: false, text: text), userId: to)
                    strongSelf.view?.clearTextField()
//                    strongSelf.changeButtonStateOn(isActive: false) //Задание
                } else {
                    strongSelf.view?.displayMessage(title: "Сообщение не доставлено!", msg: error?.localizedDescription ?? "Ошибка")
                }
            }
        }
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
        if userId == self.companionUserId {
            DispatchQueue.main.async {
                self.view?.connectionChanged(with: userId, on: on)
            }
        }
    }
    
    func didRecievedMessage(text: String, fromUser: String) {
        saveMessage(Message(isIncoming: true, text: text), userId: fromUser)
    }
    
    func setupFRC(with userId: String)  {
        let frc = frcService.configureAndGetFRC(with: frService.getMessagesFromConversationWith(userId), sectionKey: nil)
        view?.setupView(with: frc)
    }
    
}
