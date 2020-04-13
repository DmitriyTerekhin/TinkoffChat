//
//  DBAppUser.swift
//  TinkoffChat
//
//  Created by Dmitriy Terekhin on 04/04/2018.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import Foundation
import CoreData

@objc(DBAppUser)
public final class DBAppUser: NSManagedObject {
    
    @NSManaged public private(set) var avatar: Data
    @NSManaged public private(set) var name: String
    @NSManaged public private(set) var infoAboutMe: String
    
    static func insert(into context: NSManagedObjectContext, appUserModel: AppUserModel) -> DBAppUser {
        let dbAppUser: DBAppUser = context.insertObject()
        dbAppUser.avatar = appUserModel.avatar ?? Data()
        dbAppUser.name = appUserModel.name
        dbAppUser.infoAboutMe = appUserModel.someInfoAboutMe
        return dbAppUser
    }
    
    func updateProfileInfo(with profileModel: AppUserModel) {
        name = profileModel.name
        infoAboutMe = profileModel.someInfoAboutMe
        avatar = profileModel.avatar ?? Data()
    }
}

extension DBAppUser: ManagedObjectType {
    public static var entityName: String {
        return "DBAppUser"
    }
}

