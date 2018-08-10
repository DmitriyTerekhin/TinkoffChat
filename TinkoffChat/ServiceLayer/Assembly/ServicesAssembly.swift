//
//  ServicesAssembly.swift
//  TinkoffChat
//
//  Created by Dmitriy Terekhin on 24/04/2018.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import Foundation

protocol IServicesAssembly {
    var communicationService: ICommunicationService { get }
    var storageService: IUserDialogStorageService { get }
    var fetchRequestService: IFetchRequestService { get }
    var databaseAppUserInfoService: IAppUserProfileService { get }
    var diskAppUserInfoService: IAppUserProfileService { get }
    var fetchResultControllerService: IFetchResultControllerService { get }
    var imagesService: IImagesService { get }
}

class ServicesAssembly: IServicesAssembly {
    
    private let coreAssembly: ICoreAssembly
    
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
    }
    
    lazy var communicationService: ICommunicationService = CommunicationManager(communicator: coreAssembly.multipeerCommunicator)
    lazy var storageService: IUserDialogStorageService = UserStorageService(storage: coreAssembly.usersAndDialogsStorageManager, CDStack: CoreDataStack.shared)
    lazy var fetchRequestService: IFetchRequestService = FetchRequestService()
    lazy var databaseAppUserInfoService: IAppUserProfileService = AppUserProfileService(storage: coreAssembly.appUserProfileStorage, CDStack: CoreDataStack.shared)
    lazy var diskAppUserInfoService: IAppUserProfileService = MyProfileDataManager(managerType: .operation)
    lazy var fetchResultControllerService: IFetchResultControllerService = FetchResultControllerService(CDStack: CoreDataStack.shared)
    lazy var imagesService: IImagesService = ImagesService(requestSender: coreAssembly.requestSender)
}
