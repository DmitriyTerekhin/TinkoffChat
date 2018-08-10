//
//  CommunicationManager.swift
//  TinkoffChat
//
//  Created by Dmitriy Terekhin on 05/04/2018.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import Foundation

protocol CommunicationManagerDelegate: class {
    func didFoundUser(userId: String, userName: String?)
    func didLostUser(userId: String)
    func didRecieveMessage(text: String, fromUser: String, toUser: String)
}

protocol CommunicationDialogDelegate: class {
    func connectionChanged(with userId: String, on: Bool)
    func didRecievedMessage(text: String, fromUser: String)
}

protocol ICommunicationService: class {
    
    var delegate: CommunicationManagerDelegate? { get set }
    var dialogDelegate: CommunicationDialogDelegate? { get set }
    
    //discrovering
    func didFoundUser(userId: String, userName: String?)
    func didLostUser(userId: String)
    
    //errors
    func failedToStartBrowsingForUsers(error: Error)
    func failedToStartAdvertising(error: Error)
    
    //messages
    func sendMessage(string: String, to userId: String, completionHandler: ((Bool, Error?) -> ())?)
    func didRecieveMessage(text: String, fromUser: String, toUser: String)
}

class CommunicationManager: ICommunicationService {
    
    var communicator: ICommunicator
    
    weak var delegate: CommunicationManagerDelegate?
    weak var dialogDelegate: CommunicationDialogDelegate?
    
    init(communicator: ICommunicator) {
        self.communicator = communicator
        self.communicator.delegate = self
    }
    
    func sendMessage(string: String, to userId: String, completionHandler: ((Bool, Error?) -> ())?) {
        communicator.sendMessage(string: string, to: userId, completionHandler: completionHandler)
    }
    
    func didFoundUser(userId: String, userName: String?) {
        dialogDelegate?.connectionChanged(with: userId, on: true)
        delegate?.didFoundUser(userId: userId, userName: userName)
    }
    
    func didLostUser(userId: String) {
        dialogDelegate?.connectionChanged(with: userId, on: false)
        delegate?.didLostUser(userId: userId)
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        print(error.localizedDescription)
    }
    
    func failedToStartAdvertising(error: Error) {
        print(error.localizedDescription)
    }
    
    func didRecieveMessage(text: String, fromUser: String, toUser: String) {
        delegate?.didRecieveMessage(text: text, fromUser: fromUser, toUser: toUser)
    }
}
