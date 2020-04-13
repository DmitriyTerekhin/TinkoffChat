//
//  GCDDataManager.swift
//  TinkoffChat
//
//  Created by Dmitriy Terekhin on 29/03/2018.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import Foundation


class GCDDataManager: ProfileManagerProtocol {
    
    private let concurrentProfileQueue =
        DispatchQueue(
            label: "GCDProfileWorkQueue")
    
    var myProfileModel: AppUserModel
    var state = MyProfileState.new
    
    init() {
        self.myProfileModel = AppUserModel(name: "Ваше имя", someInfoAboutMe: "Информацию о себе", avatar: UIImageJPEGRepresentation(#imageLiteral(resourceName: "placeholder-user"), 1.0))
    }
    
    func saveProfileInfo(model: AppUserModel, completionHandler: @escaping OperationResultCompletionHandler) {
        concurrentProfileQueue.async {
            if NSKeyedArchiver.archiveRootObject(model, toFile: self.getPath()) {
                self.state = .writed
                completionHandler(true)
            } else {
                completionHandler(false)
                self.state = .writingfailed
            }
        }
    }
    
    func loadProfileInfo(completionHandler: @escaping LoadMyProfileCompletionHandler) {
        concurrentProfileQueue.async {
            if let model = self.loadModelFromFile() {
                self.myProfileModel = model
                self.state = .downloaded
                completionHandler(true, model)
            } else {
                self.state = .downloadingFailed
                completionHandler(false, nil)
            }
        }
    }
    
}
