//
//  MenuGroup+CoreDataProperties.swift
//  TBTest
//
//  Created by Weipeng Wu on 2019-05-08.
//  Copyright © 2019 Weipeng Wu. All rights reserved.
//
//

import Foundation
import CoreData


extension MenuGroup {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MenuGroup> {
        return NSFetchRequest<MenuGroup>(entityName: "MenuGroup")
    }

    @NSManaged public var groupImage: NSData?
    @NSManaged public var groupName: String?
    @NSManaged public var items: NSSet?

}

// MARK: Generated accessors for items
extension MenuGroup {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: MenuItem)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: MenuItem)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}
