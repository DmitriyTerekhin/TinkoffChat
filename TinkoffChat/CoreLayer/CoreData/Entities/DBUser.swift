//
//  DBUser.swift
//  TinkoffChat
//
//  Created by Дмитрий Терехин on 4/19/18.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import Foundation
import CoreData

@objc(DBUser)
public final class DBUser: NSManagedObject {
    
    @NSManaged public private(set) var id: String
    @NSManaged public private(set) var name: String
    @NSManaged public private(set) var isOnline: Bool
    @NSManaged public private(set) var conversation: DBConversation?
    
    static func insert(into context: NSManagedObjectContext, userModel: UserModel) -> DBUser {
        let dbUser: DBUser = context.insertObject()
        dbUser.id = userModel.id
        dbUser.isOnline = userModel.isOnline
        dbUser.name = userModel.name
        return dbUser
    }
    
    func updateUserStatusOn(_ isOnline: Bool) {
        self.isOnline = isOnline
    }
    
    func addConversation(_ dbConversation: DBConversation) {
        self.conversation = dbConversation
    }
    
}

extension DBUser: ManagedObjectType {
    public static var entityName: String {
        return "DBUser"
    }
}
