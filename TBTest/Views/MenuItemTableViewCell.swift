//
//  MenuItemTableViewCell.swift
//  TBTest
//
//  Created by Weipeng Wu on 2019-05-07.
//  Copyright © 2019 Weipeng Wu. All rights reserved.
//

import UIKit

class MenuItemTableViewCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCell()
    }
    
    // MARK: - Helper Methods
    func setupCell() {
        self.containerView.layer.shadowRadius = 2
        self.containerView.layer.shadowOpacity = 0.15
        self.containerView.layer.shadowColor = UIColor.black.cgColor
        self.containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.itemImageView.contentMode = .scaleAspectFill
    }

    func configureCell(name: String, price: Double, image: NSData?) {
        self.itemNameLabel.text = name
        self.itemPriceLabel.text = "$\(price)"
        if let imageData = image as Data? {
            self.itemImageView.image = UIImage(data: imageData)
        }
    }

}
