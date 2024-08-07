//
//  UIViewController+Extension.swift
//  E-Market
//
//  Created by Oğuzhan Akın on 6.08.2024.
//

import UIKit

extension UIViewController {
    func showAlert(title: String = "Success!", message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

