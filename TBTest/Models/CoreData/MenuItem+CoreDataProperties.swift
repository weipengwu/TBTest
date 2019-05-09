//
//  MenuItem+CoreDataProperties.swift
//  TBTest
//
//  Created by Weipeng Wu on 2019-05-08.
//  Copyright © 2019 Weipeng Wu. All rights reserved.
//
//

import Foundation
import CoreData


extension MenuItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MenuItem> {
        return NSFetchRequest<MenuItem>(entityName: "MenuItem")
    }

    @NSManaged public var itemImage: NSData? 
    @NSManaged public var itemName: String?
    @NSManaged public var itemPrice: Double
    @NSManaged public var group: MenuGroup?

}
