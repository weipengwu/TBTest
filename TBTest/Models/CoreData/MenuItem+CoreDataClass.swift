//
//  MenuItem+CoreDataClass.swift
//  TBTest
//
//  Created by Weipeng Wu on 2019-05-06.
//  Copyright © 2019 Weipeng Wu. All rights reserved.
//
//

import Foundation
import CoreData

@objc(MenuItem)
public class MenuItem: NSManagedObject {
    
    static func isExist(name: String, context: NSManagedObjectContext) -> Bool {
        let request: NSFetchRequest<MenuItem> = MenuItem.fetchRequest()
        request.predicate = NSPredicate(format: "itemName = %@", name)
        
        var count = 0
        
        do {
            count = try context.count(for: request)
        } catch {
            print(error)
        }
        
        return count > 0 ? true : false
    }
    
    static func createMenuItem(name: String, image: NSData, price: Double, group: String, context: NSManagedObjectContext) -> MenuItem {
        let item = MenuItem(context: context)
        item.itemName = name
        item.itemImage = image
        item.itemPrice = price
        item.group = MenuGroup.findMenuGroup(name: group, context: context)
        
        return item
    }
    
    static func deleteMenuItem(name: String, context: NSManagedObjectContext) {
        let request: NSFetchRequest<MenuItem> = MenuItem.fetchRequest()
        request.predicate = NSPredicate(format: "itemName = %@", name)
        
        do {
            let matches = try context.fetch(request)
            for obj in matches {
                context.delete(obj)
            }
        } catch {
            print(error)
        }
    }
    
    static func updateMenuItem(findName: String, newName: String, newImage: NSData, newPrice: Double, context: NSManagedObjectContext) {
        let request: NSFetchRequest<MenuItem> = MenuItem.fetchRequest()
        request.predicate = NSPredicate(format: "itemName = %@", findName)
        
        do {
            let matches = try context.fetch(request)
            for obj in matches {
                obj.itemName = newName
                obj.itemImage = newImage
                obj.itemPrice = newPrice
            }
        } catch {
            print(error)
        }
    }
}
