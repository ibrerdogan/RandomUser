//
//  BookmarksCoordinator.swift
//  RandomUser
//
//  Created by İbrahim Erdogan on 2.10.2025.
//

import Foundation
import UIKit

class BookmarksCoordinator: Coordinator {
    var navigationController: UINavigationController
    var localStorageManager: LocalStorageManager
    
    init(navigationController: UINavigationController, localStorageManager: LocalStorageManager) {
        self.navigationController = navigationController
        self.localStorageManager = localStorageManager
    }
    
    func start() {
        let viewModel = BookmarksViewModel(localStorageManager: localStorageManager)
        let vc = BookmarksViewController(viewModel: viewModel)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func showUserDetail(user: User) {
        let viewModel = UserDetailViewModel(user: user)
        let detailVC = UserDetailViewController(viewModel: viewModel)
        detailVC.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(detailVC, animated: true)
    }
}
