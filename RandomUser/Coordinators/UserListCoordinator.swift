//
//  UserListCoordinator.swift
//  RandomUser
//
//  Created by İbrahim Erdogan on 2.10.2025.
//

import Foundation
import UIKit

class UserListCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = UserListViewController()
        vc.viewModel.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showUserDetail(with user: User) {
        let viewModel = UserDetailViewModel(user: user)
        let detailVC = UserDetailViewController(viewModel: viewModel)
        detailVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(detailVC, animated: true)
    }
}
