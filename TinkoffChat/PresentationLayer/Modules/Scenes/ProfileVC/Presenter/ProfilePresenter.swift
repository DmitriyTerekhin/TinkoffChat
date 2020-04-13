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
    func saveMyProfile(with model: AppUserModel)
}

protocol IProfilePresenter: IAppUserInfoService {
    func attachView(_ view: IProfileView)
    func wasModelChanged() -> Bool
}

protocol IProfileView: class {
    func prepareAlertSheet() -> UIAlertController
    func showWritingToFileUILogic(_ show: Bool, andShowActivityIndicater: Bool)
    func setupProfile(wtih myProfileModel: AppUserModel)
    func turnEditModeUILogic(_ on: Bool)
    func makeActiveEditableElements(_ active: Bool)
    func getUpdatedUserModel() -> AppUserModel
    func displayMessage(title: String, msg: String, withAction: UIAlertAction?)
}

class ProfilePresenter: IProfilePresenter {
    
    let profileService: IAppUserProfileService
    let frService: IFetchRequestService
    private var dbModel: AppUserModel?
    weak private var view: IProfileView?
    
    init(profileService: IAppUserProfileService, frService: IFetchRequestService) {
        self.profileService = profileService
        self.frService = frService
    }
    
    func attachView(_ view: IProfileView) {
        self.view = view
    }
    
    func loadMyProfile() {
        profileService.loadMyProfile(completionHandler: { [weak self] success, appUser in
            if success, let model = appUser {
                self?.dbModel = model
                DispatchQueue.main.async {
                    self?.view?.setupProfile(wtih: model)
                }
            }
        })
    }
    
    func saveMyProfile(with model: AppUserModel) {
        profileService.saveMyProfile(with: model)  { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.view?.displayMessage(title: "Успешно сохранено", msg: "", withAction: nil)
                    self?.view?.turnEditModeUILogic(false)
                } else {
                    let repeatAction = UIAlertAction(title: "Повторить", style: .default, handler: { (_) in
                        self?.saveMyProfile(with: model)
                    })
                    self?.view?.displayMessage(title: "Ошибка", msg: "Не удалось сохранить данные", withAction: repeatAction)
                    self?.view?.turnEditModeUILogic(false)
                }
            }
        }
    }
    
    func wasModelChanged() -> Bool {
        return dbModel == view?.getUpdatedUserModel()
    }
    
}
