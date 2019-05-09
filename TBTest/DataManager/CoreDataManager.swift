//
//  CoreDataManager.swift
//  TBTest
//
//  Created by Weipeng Wu on 2019-05-04.
//  Copyright © 2019 Weipeng Wu. All rights reserved.
//

import Foundation
import CoreData


class CoreDataManager {
    
    // MARK: - Singleton
    
    static let sharedInstance = CoreDataManager()
    
    // MARK: - Life Cycle
    
    private init() {
        
    }
    
    // MARK: - Properties
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TBTest")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var context = persistentContainer.viewContext
    

    // MARK: - Core Data Saving support
    
    func saveContext (context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
