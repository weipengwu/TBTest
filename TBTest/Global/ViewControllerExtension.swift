//
//  ViewControllerExtension.swift
//  TBTest
//
//  Created by Weipeng Wu on 2019-05-08.
//  Copyright © 2019 Weipeng Wu. All rights reserved.
//

import UIKit

extension UIViewController {

    func showError(with message: String?) {
        if let message = message {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
