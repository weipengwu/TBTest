//
//  MenuItemsTableViewController.swift
//  TBTest
//
//  Created by Weipeng Wu on 2019-05-07.
//  Copyright © 2019 Weipeng Wu. All rights reserved.
//

import UIKit
import CoreData

class MenuItemsTableViewController: FetchedResultsTableViewController {
    
    // MARK: - Properties
    var group: String?
    var fetchResultController: NSFetchedResultsController<MenuItem>?
    var updateItem: MenuItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavBar()
        self.getMenuItems()
        
        self.fetchResultController?.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.allowsSelection = false
    }
    
    // MARK: - Help Methods
    func configureNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tappedAddItem))
        navigationItem.title = group ?? ""
    }

    @objc func tappedAddItem() {
        self.updateItem = nil
        self.performSegue(withIdentifier: "ShowAddMenuItemSegue", sender: self)
    }

    func getMenuItems() {
        if group != nil {
            let request: NSFetchRequest<MenuItem> = MenuItem.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "itemName", ascending: true)]
            request.predicate = NSPredicate(format: "group.groupName = %@", group!)
            self.fetchResultController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: CoreDataManager.sharedInstance.context,
                sectionNameKeyPath: nil,
                cacheName: nil)
            do {
                try self.fetchResultController?.performFetch()
                tableView.reloadData()
            } catch {
                print(error)
            }
        }
    }
    
    func deleteMenuItem(name: String) {
        CoreDataManager.sharedInstance.context.automaticallyMergesChangesFromParent = true
        CoreDataManager.sharedInstance.persistentContainer.performBackgroundTask { context in
            MenuItem.deleteMenuItem(name: name, context: context)
            
            CoreDataManager.sharedInstance.saveContext(context: context)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAddMenuItemSegue" {
            if let vc = segue.destination as? AddMenuItemViewController {
                vc.group = self.group
                vc.updateItem = self.updateItem
            }
        }
    }
}

extension MenuItemsTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchResultController?.sections?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = self.fetchResultController?.sections, sections.count > 0 {
            return sections[section].numberOfObjects
        }
        else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemTableViewCell") as? MenuItemTableViewCell {
            let itemObj = self.fetchResultController?.object(at: indexPath)
            cell.configureCell(name: itemObj?.itemName ?? "", price: itemObj?.itemPrice ?? 0.0, image: itemObj?.itemImage)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            if let itemName = self.fetchResultController?.object(at: indexPath).itemName {
                self.deleteMenuItem(name: itemName)
            }
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            if let obj = self.fetchResultController?.object(at: indexPath) {
                self.updateItem = obj
                self.performSegue(withIdentifier: "ShowAddMenuItemSegue", sender: self)
            }
        }
        
        return [delete, edit]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}
