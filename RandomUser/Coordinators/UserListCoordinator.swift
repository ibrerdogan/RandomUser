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
    var localStorageManager: LocalStorageManager
    
    init(navigationController: UINavigationController, localStorageManager: LocalStorageManager) {
        self.navigationController = navigationController
        self.localStorageManager = localStorageManager
    }
    
    func start() {
        let apiClient = APIClient()
        let viewModel = UserListViewModel(apiClient: apiClient, localStorageManager: localStorageManager)
        let vc = UserListViewController(viewModel: viewModel)
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
