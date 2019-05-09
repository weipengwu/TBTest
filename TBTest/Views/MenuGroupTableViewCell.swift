//
//  MenuGroupTableViewCell.swift
//  TBTest
//
//  Created by Weipeng Wu on 2019-05-06.
//  Copyright © 2019 Weipeng Wu. All rights reserved.
//

import UIKit

class MenuGroupTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var menuGroupNameLabel: UILabel!
    @IBOutlet weak var groupImageView: UIImageView!
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCell()
    }
    
    // MARK: - Helper Methods
    func setupCell() {
        self.groupImageView.contentMode = .scaleAspectFill
    }

    func configure(name: String, image: NSData?) {
        self.menuGroupNameLabel.text = name
        if let imageData = image as Data? {
            self.groupImageView.image = UIImage(data: imageData)
        }
    }

}
