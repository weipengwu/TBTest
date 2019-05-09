//
//  MenuGroup+CoreDataClass.swift
//  TBTest
//
//  Created by Weipeng Wu on 2019-05-06.
//  Copyright © 2019 Weipeng Wu. All rights reserved.
//
//

import Foundation
import CoreData

@objc(MenuGroup)
public class MenuGroup: NSManagedObject {
    
    static func isExist(name: String, context: NSManagedObjectContext) -> Bool {
        let request: NSFetchRequest<MenuGroup> = MenuGroup.fetchRequest()
        request.predicate = NSPredicate(format: "groupName = %@", name)
        
        var count = 0
        
        do {
            count = try context.count(for: request)
        } catch {
            print(error)
        }
        
        return count > 0 ? true : false
    }
    
    static func findMenuGroup(name: String, context: NSManagedObjectContext) -> MenuGroup? {
        let request: NSFetchRequest<MenuGroup> = MenuGroup.fetchRequest()
        request.predicate = NSPredicate(format: "groupName = %@", name)
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                return matches[0]
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
    static func createMenuGroup(name: String, image: NSData, context: NSManagedObjectContext) -> MenuGroup {
        let group = MenuGroup(context: context)
        group.groupName = name
        group.groupImage = image
        
        return group
    }
    
    static func deleteMenuGroup(name: String, context: NSManagedObjectContext) {
        let request: NSFetchRequest<MenuGroup> = MenuGroup.fetchRequest()
        request.predicate = NSPredicate(format: "groupName = %@", name)
        
        do {
            let matches = try context.fetch(request)
            for obj in matches {
                context.delete(obj)
            }
        } catch {
            print(error)
        }
    }
    
    static func updateMenuGroup(findName: String, newName: String, newImage: NSData, context: NSManagedObjectContext) {
        let request: NSFetchRequest<MenuGroup> = MenuGroup.fetchRequest()
        request.predicate = NSPredicate(format: "groupName = %@", findName)
        
        do {
            let matches = try context.fetch(request)
            for obj in matches {
                obj.groupImage = newImage
                obj.groupName = newName
            }
        } catch {
            print(error)
        }
    }
}
