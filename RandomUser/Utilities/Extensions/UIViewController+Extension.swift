//
//  UIViewController+Extension.swift
//  RandomUser
//
//  Created by İbrahim Erdogan on 6.10.2025.
//

import Foundation
import UIKit

extension UIViewController {
    func showErrorPopup(title: String = "Error", message: String, buttonTitle: String = "OK") {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: buttonTitle, style: .default))
            self.present(alert, animated: true)
        }
    }
}
