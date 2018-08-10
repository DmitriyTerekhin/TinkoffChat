//
//  AppUserModel.swift
//  TinkoffChat
//
//  Created by Dmitriy Terekhin on 28/03/2018.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import Foundation

class AppUserModel: NSObject, NSCoding {
    let name: String
    let someInfoAboutMe: String
    let avatar: Data?
    
    init(name: String, someInfoAboutMe: String, avatar: Data?) {
        self.name = name
        self.someInfoAboutMe = someInfoAboutMe
        self.avatar = avatar
    }
    
    convenience init(from dbAppUser: DBAppUser) {
        self.init(name: dbAppUser.name, someInfoAboutMe: dbAppUser.infoAboutMe, avatar: dbAppUser.avatar)
    }

    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        someInfoAboutMe = aDecoder.decodeObject(forKey: "someInfoAboutMe") as! String
        avatar = aDecoder.decodeObject(forKey: "avatar") as? Data
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(someInfoAboutMe, forKey: "someInfoAboutMe")
        aCoder.encode(avatar, forKey: "avatar")
    }
    
}
