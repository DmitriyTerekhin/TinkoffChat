//
//  ThemeService.swift
//  TinkoffChat
//
//  Created by Дмитрий Терехин on 5/29/18.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import Foundation

@objc(IThemeService)
public protocol IThemeService: NSObjectProtocol {
    func getColor(from: Themes, with id: Int) -> UIColor?
}

@objc class ThemesService: NSObject, IThemeService {
    func getColor(from themes: Themes, with id: Int) -> UIColor? {
        switch id {
        case 1:
            return themes.theme1
        case 2:
            return themes.theme2
        case 3:
            return themes.theme3
        default: return nil
        }
    }
}
