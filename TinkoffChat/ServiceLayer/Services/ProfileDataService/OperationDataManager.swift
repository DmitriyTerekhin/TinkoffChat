//
//  OperationDataManager.swift
//  TinkoffChat
//
//  Created by Дмитрий Терехин on 3/29/18.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import UIKit

enum MyProfileState {
    case new, downloaded, writed, writingfailed, downloadingFailed
}

class OperationDataManager: ProfileManagerProtocol {
    
    var myProfileModel: AppUserModel
    var state = MyProfileState.new
    private let operations = PendingOperations()
    
    init() {
        self.myProfileModel = AppUserModel(name: "Ваше имя", someInfoAboutMe: "Информацию о себе", avatar: UIImageJPEGRepresentation(#imageLiteral(resourceName: "placeholder-user"), 1.0))
    }
    
    func saveProfileInfo(model: AppUserModel, completionHandler: @escaping OperationResultCompletionHandler) {
        
        myProfileModel = model
        let writer = MyProfileWriter(myProfileManager: self)
        
        writer.completionBlock = {
            
            if writer.isCancelled {
                completionHandler(false)
            }
            
            if self.state != .writingfailed {
                completionHandler(true)
            }
            
            if self.state == .writingfailed {
                completionHandler(false)
            }
        }
        
        operations.workWithProfileQueue.addOperation(writer)
    }
    
    func loadProfileInfo(completionHandler: @escaping LoadMyProfileCompletionHandler) {
        
        let downloader = MyProfileDownloader(myProfilManager: self)
        
        downloader.completionBlock = {
            if downloader.isCancelled {
                completionHandler(false, nil)
            }
            
            if self.state != .downloadingFailed {
                completionHandler(true, self.myProfileModel)
            }
        }
        operations.workWithProfileQueue.addOperation(downloader)
    }
}

class PendingOperations {
    lazy var workWithProfileQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "ProfileWorkQueue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
}

class MyProfileDownloader: Operation {
    
    let myProfilManager: OperationDataManager
    
    
    init(myProfilManager: OperationDataManager) {
        self.myProfilManager = myProfilManager
    }
    
    override func main() {
        
        if self.isCancelled {
            return
        }
        
        let profileModel = loadModelFromFile()

        if self.isCancelled {
            return
        }
        
        if let model = profileModel {
            myProfilManager.myProfileModel = model
            myProfilManager.state = .downloaded
        } else {
            myProfilManager.state = .downloadingFailed
        }
        
    }
    
    private func loadModelFromFile() -> AppUserModel? {
        guard let myProfile: AppUserModel = NSKeyedUnarchiver.unarchiveObject(withFile: myProfilManager.getPath()) as? AppUserModel else {return nil}
      return myProfile
    }
}

class MyProfileWriter: Operation {
    
    let myProfileManager: OperationDataManager
    
    init(myProfileManager: OperationDataManager) {
        self.myProfileManager = myProfileManager
    }
    
    override func main () {
        
        if self.isCancelled {
            return
        }
        
        if writeToFileWithSuccess() {
            myProfileManager.state = .writed
        } else {
            myProfileManager.state = .writingfailed
        }
    }
    
    private func writeToFileWithSuccess() -> Bool {
        if NSKeyedArchiver.archiveRootObject(myProfileManager.myProfileModel, toFile: myProfileManager.getPath()) {
            return true
        } else {
            return false
        }
    }
    
}
