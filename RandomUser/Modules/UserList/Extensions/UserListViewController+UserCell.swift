//
//  UserListViewController+UserCell.swift
//  RandomUser
//
//  Created by İbrahim Erdogan on 5.10.2025.
//

import Foundation
import UIKit

extension UserListViewController: UserCellProtocol {
    func bookmarkTapped(for user: User) {
        viewModel.manageUserBookMark(for: user)
    }
}
