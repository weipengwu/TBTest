//
//  AddMenuGroupViewController.swift
//  TBTest
//
//  Created by Weipeng Wu on 2019-05-06.
//  Copyright © 2019 Weipeng Wu. All rights reserved.
//

import UIKit

class AddMenuGroupViewController: AddViewController {
    

    //MARK: - Outlets
    @IBOutlet weak var groupNameTextField: UITextField!
    
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var removeImageButton: UIButton!
    
    //MARK: - Properties
    var updateGroup: MenuGroup?
    var findName: String?
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavBar()
        self.configureButtons()
        self.populateGroupFields()
        self.groupImageView.contentMode = .scaleAspectFill
    }
    
    // MARK: - Helper Methods
    func configureButtons() {
        self.addImageButton.setTitle("Add", for: .normal)
        self.removeImageButton.setTitle("Remove", for: .normal)
        self.addImageButton.addTarget(self, action: #selector(addImage), for: .touchUpInside)
        self.removeImageButton.addTarget(self, action: #selector(removeImage), for: .touchUpInside)
    }
    
    @objc func addImage() {
        self.presentPhotoLibrary()
    }
    @objc func removeImage() {
        self.groupImageView.image = nil
        self.image = nil
    }
    
    func populateGroupFields() {
        if let updateGroup = self.updateGroup {
            self.findName = updateGroup.groupName
            self.groupNameTextField.text = updateGroup.groupName
            if let imageData = updateGroup.groupImage as Data? {
                self.groupImageView.image = UIImage(data: imageData)
                self.image = UIImage(data: imageData)
            }
        }
    }
    
    func validateFields() -> Bool {
        if let name = self.groupNameTextField.text {
            if name.isEmpty {
                self.showError(with: "Group name can not be empty.")
                return false
            }
            else {
                if self.updateGroup == nil && MenuGroup.isExist(name: name, context: CoreDataManager.sharedInstance.context) {
                    self.showError(with: "Group name exsits.")
                    return false
                }
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
            if let imageData = convertImageToNSData(image: self.image), let name = self.groupNameTextField.text, name.count > 0 {
                CoreDataManager.sharedInstance.context.automaticallyMergesChangesFromParent = true
                CoreDataManager.sharedInstance.persistentContainer.performBackgroundTask { [weak self] context in
                    
                    if let _ = self?.updateGroup, let findName = self?.findName {
                        MenuGroup.updateMenuGroup(findName: findName, newName: name, newImage: imageData, context: context)
                    }
                    else {
                        _ = MenuGroup.createMenuGroup(name: name, image: imageData, context: context)
                    }
                    
                    CoreDataManager.sharedInstance.saveContext(context: context)
                }
                
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    override func updateImageView() {
        self.groupImageView.image = self.image
    }
}

