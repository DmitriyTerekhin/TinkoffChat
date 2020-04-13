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
    func themesViewController(themes: Themes) -> ThemesViewController
    
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
    
    func themesViewController(themes: Themes) -> ThemesViewController {
        let themeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ThemeIdentifier") as!ThemesViewController
        themeVC.model = themes
        themeVC.themeService = serviceAssembly.themeService
        return themeVC
    }
    
    func conversationListViewController() -> ConversationsListViewController {
        let presenter = ConversationListPresenter(storage: serviceAssembly.storageService,
                                          communicationService: serviceAssembly.communicationService,
                                                                 fetchRequestService: serviceAssembly.fetchRequestService,
                                                                 fetchResultControllerService: serviceAssembly.fetchResultControllerService)
        return ConversationsListViewController(presenter: presenter, presentationAssembly: self)
    }
    
    func conversationViewControllerWith(_ userId: String, userName: String) -> ConversationViewController {
        let presenter = ConversationPresenter(storage: serviceAssembly.storageService,
                                      communicationService: serviceAssembly.communicationService,
                                                     fetchRequestService: serviceAssembly.fetchRequestService,
                                                     fetchResultControllerService: serviceAssembly.fetchResultControllerService, companionUserId: userId)
        return ConversationViewController(presenter: presenter, userName: userName)
    }
    
    func profileViewController() -> UINavigationController {
        
        let profilePresenter: IProfilePresenter = ProfilePresenter (
            profileService: serviceAssembly.databaseAppUserInfoService,
            frService: serviceAssembly.fetchRequestService
        )
        let navC = UINavigationController(rootViewController: ProfileViewController(profilePresenter: profilePresenter, presentationAssembly: self))
        navC.modalPresentationStyle = .fullScreen
        return navC
    }
    
    func imagesLibraryViewController() -> ImagesLibraryViewController {
        let presenter = ImagesLibraryPresenter(imageService: serviceAssembly.imagesService)
        return ImagesLibraryViewController(presenter: presenter)
    }
    
}
