//
//  PresentationAssembly.swift
//  TinkoffChat
//
//  Created by Dmitriy Terekhin on 24/04/2018.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import UIKit

protocol IPresentationAssembly {
    
    /// Создает экран с выбором тем
    func themesViewController() -> ThemesViewController
    
    /// Создает экран со списком диалогов
    func conversationListViewController() -> ConversationsListViewController
    
    /// Создает экран диалога с конкретным пользователем
    func conversationViewControllerWith(_ userId: String, userName: String) -> ConversationViewController 
    
    /// Создает экран с профилем
    func profileViewController() -> UINavigationController
    
    func imagesLibraryViewController() -> ImagesLibraryViewController
}

class PresentationAssembly: IPresentationAssembly {
    
    private let serviceAssembly: IServicesAssembly
    
    init(serviceAssembly: IServicesAssembly) {
        self.serviceAssembly = serviceAssembly
    }
    
    func themesViewController() -> ThemesViewController {
        let themeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ThemeIdentifier") as!ThemesViewController
        return themeVC
    }
    
    func conversationListViewController() -> ConversationsListViewController {
        let model = ConversationListModel(storage: serviceAssembly.storageService,
                                          communicationService: serviceAssembly.communicationService,
                                                                 fetchRequestService: serviceAssembly.fetchRequestService,
                                                                 fetchResultControllerService: serviceAssembly.fetchResultControllerService)
        return ConversationsListViewController(model: model, presentationAssembly: self)
    }
    
    func conversationViewControllerWith(_ userId: String, userName: String) -> ConversationViewController {
        let model = ConversationModel(storage: serviceAssembly.storageService,
                                      communicationService: serviceAssembly.communicationService,
                                                     fetchRequestService: serviceAssembly.fetchRequestService,
                                                     fetchResultControllerService: serviceAssembly.fetchResultControllerService)
        return ConversationViewController(model: model, userId: userId, userName: userName)
    }
    
    func profileViewController() -> UINavigationController {
        
        let profileModel = ProfileModel(
            profileService: serviceAssembly.databaseAppUserInfoService,
                                    frService: serviceAssembly.fetchRequestService
        )
        
        return UINavigationController(rootViewController: ProfileViewController(profileModel: profileModel, presentationAssembly: self))
    }
    
    func imagesLibraryViewController() -> ImagesLibraryViewController {
        let imagesLibraryModel = ImagesLibraryModel(imageService: serviceAssembly.imagesService)
        return ImagesLibraryViewController(model: imagesLibraryModel)
    }
    
}
