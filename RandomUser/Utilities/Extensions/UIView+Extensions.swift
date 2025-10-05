//
//  UIView+Extensions.swift
//  RandomUser
//
//  Created by İbrahim Erdogan on 5.10.2025.
//

import Foundation
import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { view in
            addSubview(view)
        }
    }
}
