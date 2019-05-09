//
//  AddMenuItemViewController.swift
//  TBTest
//
//  Created by Weipeng Wu on 2019-05-07.
//  Copyright © 2019 Weipeng Wu. All rights reserved.
//

import UIKit

class AddMenuItemViewController: AddViewController {
    
    //MARK: - Outlets

    @IBOutlet weak var itemNameTextField: UITextField!
    
    @IBOutlet weak var itemPriceTextField: UITextField!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var addItemImageButtom: UIButton!
    @IBOutlet weak var removeItemImageButton: UIButton!
    
    // MARK: - Properties
    var group: String?
    var updateItem: MenuItem?
    var findName: String?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureButtons()
        self.populateItemFields()
        self.itemImageView.contentMode = .scaleAspectFill
    }
    
    // MARK: - Helper Methods
    func configureButtons() {
        self.addItemImageButtom.setTitle("Add", for: .normal)
        self.removeItemImageButton.setTitle("Remove", for: .normal)
        self.addItemImageButtom.addTarget(self, action: #selector(addImage), for: .touchUpInside)
        self.removeItemImageButton.addTarget(self, action: #selector(removeImage), for: .touchUpInside)
    }
    
    func populateItemFields() {
        if let updateItem = self.updateItem {
            self.findName = updateItem.itemName
            self.itemNameTextField.text = updateItem.itemName
            self.itemPriceTextField.text = "\(updateItem.itemPrice)"
            self.group = updateItem.group?.groupName
            if let imageData = updateItem.itemImage as Data? {
                self.itemImageView.image = UIImage(data: imageData)
                self.image = UIImage(data: imageData)
            }
        }
    }
    
    @objc func addImage() {
        self.presentPhotoLibrary()
    }
    
    @objc func removeImage() {
        self.itemImageView.image = nil
        self.image = nil
    }
    
    func validateFields() -> Bool {
        if let name = self.itemNameTextField.text, let price = self.itemPriceTextField.text {
            if name.isEmpty {
                self.showError(with: "Item name can not be empty.")
                return false
            }
            else {
                if self.updateItem == nil && MenuItem.isExist(name: name, context: CoreDataManager.sharedInstance.context) {
                    self.showError(with: "Item name exsits.")
                    return false
                }
            }
            
            if let doublePrice = Double(price), doublePrice < 0 || Double(price) == nil {
                self.showError(with: "Invalid price.")
                return false
            }
        }
        else {
            self.showError(with: "Unknown error.")
            return false
        }
        
        if self.image == nil {
            self.showError(with: "Image missing.")
            return false
        }
        
        return true
    }
    
    override func createOrUpdateMenu() {
        if self.validateFields() {
            if let name = self.itemNameTextField.text,
                let price = self.itemPriceTextField.text,
                let image = self.convertImageToNSData(image: self.image),
                let menuGroup = self.group {
                CoreDataManager.sharedInstance.context.automaticallyMergesChangesFromParent = true
                CoreDataManager.sharedInstance.persistentContainer.performBackgroundTask { [weak self] context in
                    if let _ = self?.updateItem, let findName = self?.findName {
                        MenuItem.updateMenuItem(findName: findName, newName: name, newImage: image, newPrice: Double(price) ?? 0.0, context: context)
                    }
                    else {
                        let _ = MenuItem.createMenuItem(name: name, image: image, price: Double(price) ?? 0.0, group: menuGroup, context: context)
                        
                    }
                    
                    CoreDataManager.sharedInstance.saveContext(context: context)
                }
                
                self.navigationController?.popViewController(animated: true)
                
            }
        }
        
    }
    
    override func updateImageView() {
        self.itemImageView.image = self.image
    }
    
}
