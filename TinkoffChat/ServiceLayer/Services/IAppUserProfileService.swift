//
//  IAppUserProfileService.swift
//  TinkoffChat
//
//  Created by Дмитрий Терехин on 8/8/18.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import Foundation

protocol IAppUserProfileService {
    func saveMyProfile(with model: AppUserModel, completionHandler: @escaping SavingMyProfileCompletionHandler)
    func loadMyProfile(completionHandler: @escaping LoadMyProfileCompletionHandler)
}

class AppUserProfileService: IAppUserProfileService {
    
    let storage: IProfileStorageManager
    let CDStack: ICoreDataStack
    
    init(storage: IProfileStorageManager, CDStack: ICoreDataStack) {
        self.storage = storage
        self.CDStack = CDStack
    }
    
    func saveMyProfile(with model: AppUserModel, completionHandler: @escaping SavingMyProfileCompletionHandler) {
        storage.saveMyProfile(with: model, into: CDStack.saveContext, completionHandler: completionHandler)
    }
    
    func loadMyProfile(completionHandler: @escaping LoadMyProfileCompletionHandler) {
        let appUser = storage.loadMyProfile(by: CDStack.mainContext)
        completionHandler(true, appUser)
    }
}
