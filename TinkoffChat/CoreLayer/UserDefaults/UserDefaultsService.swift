//
//  UserDefaultsService.swift
//  TinkoffChat
//
//  Created by Дмитрий Терехин on 3/20/18.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import Foundation

protocol IAppSettingsStorage {
    func loadAppTheme() -> UIColor?
    func saveAppThemeColor(_ color: UIColor)
}

extension UserDefaults: IAppSettingsStorage {
    
    static private let appThemeColorKey = "appThemeColorKey"
    
    func loadAppTheme() -> UIColor? {
        guard let colorData = data(forKey: UserDefaults.appThemeColorKey) else {
            return nil
        }
        return NSKeyedUnarchiver.unarchiveObject(with: colorData) as? UIColor
    }
    
    func saveAppThemeColor(_ color: UIColor) {
        let colorData = NSKeyedArchiver.archivedData(withRootObject: color)
        set(colorData, forKey: UserDefaults.appThemeColorKey)
    }
}
