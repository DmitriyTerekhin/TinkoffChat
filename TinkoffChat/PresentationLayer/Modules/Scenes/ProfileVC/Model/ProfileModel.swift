//
//  ProfileModel.swift
//  TinkoffChat
//
//  Created by Дмитрий Терехин on 4/26/18.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import Foundation

protocol IAppUserInfoService {
    func loadMyProfile()
    func saveMyProfile(with model: AppUserModel, completionHandler: @escaping SavingMyProfileCompletionHandler)
}

protocol IProfileModel: IAppUserInfoService {
    var delegate: IProfileModelDelegate? { get set }
}

protocol IProfileModelDelegate {
    func setupProfile(wtih myProfileModel: AppUserModel)
}

class ProfileModel: IProfileModel {
    
    var delegate: IProfileModelDelegate?
    
    let profileService: IAppUserProfileService
    let frService: IFetchRequestService
    
    init(profileService: IAppUserProfileService, frService: IFetchRequestService) {
        self.profileService = profileService
        self.frService = frService
    }
    
    func loadMyProfile() {
        profileService.loadMyProfile(completionHandler: { [weak self] success, appUser in
            if success, let model = appUser {
                DispatchQueue.main.async(execute: {
                    self?.delegate?.setupProfile(wtih: model)
                })
            }
        })
    }
    
    func saveMyProfile(with model: AppUserModel, completionHandler: @escaping SavingMyProfileCompletionHandler) {
        profileService.saveMyProfile(with: model, completionHandler: completionHandler)
    }
    
}
