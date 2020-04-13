//
//  FetchResultControllerService.swift
//  TinkoffChat
//
//  Created by Дмитрий Терехин on 4/19/18.
//  Copyright © 2018 Dmitriy Terekhin. All rights reserved.
//

import Foundation
import CoreData

protocol IFetchResultControllerService {
    func configureAndGetFRC<T:NSFetchRequestResult>(with fetchRequest: NSFetchRequest<T>, sectionKey: String?) -> NSFetchedResultsController<T>
}

class FetchResultControllerService: IFetchResultControllerService {
    
    private let CDStack: ICoreDataStack
    
    init(CDStack: ICoreDataStack) {
        self.CDStack = CDStack
    }
    
    func configureAndGetFRC<T>(with fetchRequest: NSFetchRequest<T>, sectionKey: String?) -> NSFetchedResultsController<T> where T : NSFetchRequestResult {
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: CDStack.mainContext,
                                             sectionNameKeyPath: sectionKey ?? nil,
                                             cacheName: nil)
        return frc
    }
    
}
