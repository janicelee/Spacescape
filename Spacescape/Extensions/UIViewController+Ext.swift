//
//  UIViewController+Ext.swift
//  Spacescape
//
//  Created by Janice Lee on 2021-05-24.
//

import UIKit

extension UIViewController {
    
    func presentErrorAlertOnMainThread(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
