//
//  MenuGroupTableViewController.swift
//  TBTest
//
//  Created by Weipeng Wu on 2019-05-07.
//  Copyright © 2019 Weipeng Wu. All rights reserved.
//

import UIKit
import CoreData

class MenuGroupTableViewController: FetchedResultsTableViewController {

    // MARK: - Properties
    var fetchResultController: NSFetchedResultsController<MenuGroup>?
    var selectedGroup: String?
    var updateGroup: MenuGroup?
    
    // MARK: - Lift Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavBar()
        self.getMenuGroup()

        self.fetchResultController?.delegate = self
        tableView.separatorStyle = .none
    }

    // MARK: - Help Methods
    func configureNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tappedAddGroup))
        navigationItem.title = "Menu"
    }
    
    @objc func tappedAddGroup() {
        self.updateGroup = nil
        self.performSegue(withIdentifier: "ShowAddMenuGroupSegue", sender: self)
    }
    
    func getMenuGroup() {
        let request: NSFetchRequest<MenuGroup> = MenuGroup.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "groupName", ascending: true)]
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
    
    func deleteMenuGroup(name: String) {
        CoreDataManager.sharedInstance.context.automaticallyMergesChangesFromParent = true
        CoreDataManager.sharedInstance.persistentContainer.performBackgroundTask { context in
            MenuGroup.deleteMenuGroup(name: name, context: context)
    
            CoreDataManager.sharedInstance.saveContext(context: context)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "ShowAddMenuGroupSegue":
            if let vc = segue.destination as? AddMenuGroupViewController {
                vc.updateGroup = self.updateGroup
            }
        case "ShowMenuItemSegue":
            if let vc = segue.destination as? MenuItemsTableViewController {
                vc.group = self.selectedGroup
            }
        default:
            break
        }

    }
}

extension MenuGroupTableViewController {
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
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MenuGroupTableViewCell") as? MenuGroupTableViewCell {
            cell.configure(name: self.fetchResultController?.object(at: indexPath).groupName ?? "", image: self.fetchResultController?.object(at: indexPath).groupImage)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedGroup = self.fetchResultController?.object(at: indexPath).groupName
        self.performSegue(withIdentifier: "ShowMenuItemSegue", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            if let groupName = self.fetchResultController?.object(at: indexPath).groupName {
                self.deleteMenuGroup(name: groupName)
            }
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            if let obj = self.fetchResultController?.object(at: indexPath) {
                self.updateGroup = obj
                self.performSegue(withIdentifier: "ShowAddMenuGroupSegue", sender: self)
            }
        }
        
        return [delete, edit]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}
