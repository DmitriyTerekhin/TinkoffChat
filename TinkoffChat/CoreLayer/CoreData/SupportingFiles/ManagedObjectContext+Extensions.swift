//
//  ManagedObjectContext+Eztensions.swift
//  TinkoffChat
//
//  Created by Dmitriy Terekhin on 04/04/2018.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    
    func insertObject<A: ManagedObjectType> () -> A {
        guard let obj = NSEntityDescription.insertNewObject(forEntityName: A.entityName, into: self) as? A else { fatalError("Wrong object type") }
        return obj
    }
    
    func performSave(completionHandler:(()-> Void)?) {
        if  hasChanges {
            perform {
                do {
                    try self.save()
                } catch {
                    print("Context save error: \(error)")
                }
                
                if let parent = self.parent {
                    parent.performSave(completionHandler: completionHandler)
                } else {
                    completionHandler?()
                }
            }
        } else {
            completionHandler?()
        }
    }
}

// Для поиска одного объекта
private let SingleObjectCacheKey = "SingleObjectCache"
private typealias SingleObjectCache = [String:NSManagedObject]

extension NSManagedObjectContext {
    
    public func set(_ object: NSManagedObject?, forSingleObjectCacheKey key: String) {
        var cache = userInfo[SingleObjectCacheKey] as? SingleObjectCache ?? [:]
        cache[key] = object
        userInfo[SingleObjectCacheKey] = cache
    }
    
    public func object(forSingleObjectCacheKey key: String) -> NSManagedObject? {
        guard let cache = userInfo[SingleObjectCacheKey] as? [String:NSManagedObject] else { return nil }
        return cache[key]
    }
    
}
