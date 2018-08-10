//
//  CoreAssembly.swift
//  TinkoffChat
//
//  Created by Dmitriy Terekhin on 24/04/2018.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import Foundation

protocol ICoreAssembly {
    var multipeerCommunicator: ICommunicator { get }
    var usersAndDialogsStorageManager: IUsersAndDialogsStorageManager { get }
    var appSettingStorage: IAppSettingsStorage { get }
    var requestSender: IRequestSender { get }
    var appUserProfileStorage: IProfileStorageManager { get }
}

class CoreAssembly: ICoreAssembly {
    lazy var multipeerCommunicator: ICommunicator = MultipeerCommunicator()
    lazy var usersAndDialogsStorageManager: IUsersAndDialogsStorageManager = StorageManager.shared
    lazy var appUserProfileStorage: IProfileStorageManager = StorageManager.shared
    lazy var appSettingStorage: IAppSettingsStorage = UserDefaults.standard
    lazy var requestSender: IRequestSender = RequestSender()
}
