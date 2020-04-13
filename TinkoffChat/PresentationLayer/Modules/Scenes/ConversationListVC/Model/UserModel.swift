//
//  UserModel.swift
//  TinkoffChat
//
//  Created by Dmitriy Terekhin on 19/04/2018.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import Foundation

struct UserModel {
    var id: String
    var name: String
    var isOnline: Bool
    
    init (id: String, name: String, isOnline: Bool) {
        self.id = id
        self.name = name
        self.isOnline = isOnline
    }
    
    init(from dbUser: DBUser) {
        self.init(id: dbUser.id, name: dbUser.name, isOnline: dbUser.isOnline)
    }
}
