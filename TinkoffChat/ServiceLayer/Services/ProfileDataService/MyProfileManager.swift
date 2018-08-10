//
//  MyProfileManager.swift
//  TinkoffChat
//
//  Created by Dmitriy Terekhin on 29/03/2018.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import Foundation


typealias LoadMyProfileCompletionHandler = (Bool, AppUserModel?) -> ()
typealias OperationResultCompletionHandler = (Bool)->()

protocol ProfileManagerProtocol {
    func getPath() -> String
    func saveProfileInfo(model: AppUserModel, completionHandler: @escaping OperationResultCompletionHandler)
    func loadModelFromFile() -> AppUserModel?
    func loadProfileInfo(completionHandler: @escaping LoadMyProfileCompletionHandler)
    var myProfileModel: AppUserModel {get set}
    var state: MyProfileState {get set}
}

extension ProfileManagerProtocol {
    
    func loadModelFromFile() -> AppUserModel? {
        guard let myProfile: AppUserModel = NSKeyedUnarchiver.unarchiveObject(withFile: getPath()) as? AppUserModel else {return nil}
        return myProfile
    }
    
    func getPath() -> String {
        return NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)[0].appending("/profileModel.txt")
    }
}

enum ManagerType {
    case GCD, operation
}

class MyProfileDataManager: IAppUserProfileService {
    
    private var manager: ProfileManagerProtocol
    private let GCDmanager: GCDDataManager
    private let operationsManager: OperationDataManager
    var myProfileModel: AppUserModel? = nil
    
    init(managerType: ManagerType = .operation) {
        
        let gcdMan = GCDDataManager()
        let operMan = OperationDataManager()
        self.GCDmanager = gcdMan
        self.operationsManager = operMan
        
        switch managerType {
        case .GCD:
            self.manager = gcdMan
        case .operation:
            self.manager = operMan
        }
    }
    
    func loadMyProfile(completionHandler: @escaping LoadMyProfileCompletionHandler) {
        manager.loadProfileInfo(completionHandler: completionHandler)
    }
    
    func saveMyProfile(with model: AppUserModel, completionHandler: @escaping SavingMyProfileCompletionHandler) {
        manager.saveProfileInfo(model: model, completionHandler: completionHandler)
    }
    
}
