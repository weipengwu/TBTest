//
//  AddViewController.swift
//  TBTest
//
//  Created by Weipeng Wu on 2019-05-07.
//  Copyright © 2019 Weipeng Wu. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {
    
    var image: UIImage? 

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavBar()
    }
    
    func configureNavBar() {
        navigationItem.title = "Add"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(createOrUpdateMenu))
    }
    
    @objc func createOrUpdateMenu() {
        
    }
    
    func convertImageToNSData(image: UIImage?) -> NSData? {
        var groupImageData: NSData?
        
        if let groupImage = image {
            if let imageData =  groupImage.pngData() as NSData? {
                groupImageData = imageData
            }
            else if let imageData = groupImage.jpegData(compressionQuality: 1) as NSData? {
                groupImageData = imageData
            }
        }
        
        return groupImageData
    }
    
    func presentPhotoLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func updateImageView() {
        
    }
    
}

extension AddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.image = chosenImage
            self.updateImageView()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
