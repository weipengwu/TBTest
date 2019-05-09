//
//  TBTestTests.swift
//  TBTestTests
//
//  Created by Weipeng Wu on 2019-05-03.
//  Copyright © 2019 Weipeng Wu. All rights reserved.
//

import XCTest
import CoreData
@testable import TBTest

class TBTestTests: XCTestCase {

    var saveNotificationCompleteHandler: ((Notification)->())?
    
    override func setUp() {
       NotificationCenter.default.addObserver(self, selector: #selector(contextSaved(notification:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
    }

    override func tearDown() {

    }
    
    func contextSaved( notification: Notification ) {
        saveNotificationCompleteHandler?(notification)
    }
    
    func waitForSavedNotification(completeHandler: @escaping ((Notification)->()) ) {
        saveNotificationCompleteHandler = completeHandler
    }
    
    func testCoreDataManager(){
        let instance = CoreDataManager.sharedInstance
        XCTAssertNotNil(instance)
    }
    
    func testCoreDataStackInitialization() {
        let coreDataStack = CoreDataManager.sharedInstance.persistentContainer
        XCTAssertNotNil(coreDataStack)
    }
    
    func testCreateMenuGroup() {
        let bundle = Bundle(for: TBTestTests.self)
        let groupImage = UIImage.init(named: "Gradient", in: bundle, compatibleWith: nil)
        guard let imageData = groupImage?.pngData() as NSData?
            else {
                return
        }
        let context = CoreDataManager.sharedInstance.context
        let group = MenuGroup.createMenuGroup(name: "test", image: imageData, context: context)
        XCTAssertNotNil(group)
    }
    
    func testSave() {
        let expect = expectation(description: "Context Saved")
        waitForSavedNotification { (notification) in
            expect.fulfill()
        }
        
        let bundle = Bundle(for: TBTestTests.self)
        let groupImage = UIImage.init(named: "Gradient", in: bundle, compatibleWith: nil)
        guard let imageData = groupImage?.pngData() as NSData?
            else {
                return
        }
        let context = CoreDataManager.sharedInstance.context
        let _ = MenuGroup.createMenuGroup(name: "testSave", image: imageData, context: context)
        CoreDataManager.sharedInstance.saveContext(context: context)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFindMenuGroup() {
        let name = "test"
        let group = MenuGroup.findMenuGroup(name: name, context: CoreDataManager.sharedInstance.context)
        XCTAssertNotNil(group)
    }
    
    func testDeleteMenuGroup() {
        let context = CoreDataManager.sharedInstance.context

        let count = try? context.count(for: MenuGroup.fetchRequest())
        let itemCount = count
        
        
        MenuGroup.deleteMenuGroup(name: "testSave", context: context)
        
        CoreDataManager.sharedInstance.saveContext(context: context)
        
        guard let newCount = try? context.count(for: MenuGroup.fetchRequest()), let oldCount = itemCount else {
            return
        }
        XCTAssertEqual(newCount, oldCount - 1)
    }
    
    func testUpdateGroup() {
        var originalName = ""
        let context = CoreDataManager.sharedInstance.context
        if let groups = try? context.fetch(MenuGroup.fetchRequest()) as? [MenuGroup] {
            if let group = groups.first{
                originalName = group.groupName ?? ""
                MenuGroup.updateMenuGroup(findName: originalName, newName: "\(originalName)Update", newImage: group.groupImage!, context: context)
                
                CoreDataManager.sharedInstance.saveContext(context: context)
                
                if let newGroups = try? context.fetch(MenuGroup.fetchRequest()) as? [MenuGroup] {
                    if let newGroup = newGroups.first {
                        XCTAssertTrue(originalName != newGroup.groupName, "Update Successfully")
                    }
                }
            }
        }
        
        
        
    }

}
