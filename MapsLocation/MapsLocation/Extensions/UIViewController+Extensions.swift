//
//  UIViewController+Extensions.swift
//  MapsLocation
//
//  Created by Alexey on 23.08.2021.
//

import UIKit

extension UIViewController {
    func showAlert(with title: String, message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        actions.forEach { action in
            alert.addAction(action)
        }
        
        self.present(alert, animated: true, completion: nil)
    }
}
