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
    
    static func ==(lhs: AppUserModel, rhs: AppUserModel) -> Bool {
        guard lhs.name == rhs.name else {return false}
        guard lhs.someInfoAboutMe == rhs.someInfoAboutMe else {return false}
        guard areEqualImages(data1: lhs.avatar, data2: rhs.avatar) == false else {return false}
        return true
    }
    
    static private func areEqualImages(data1: Data?, data2: Data?) -> Bool {
        guard let data1 = data1 as NSData? else {return false}
        guard let data2 = data2 else {return false}
        return data1.isEqual(to: data2)
    }
    
}
