//
//  AppCoordinator.swift
//  RandomUser
//
//  Created by İbrahim Erdogan on 2.10.2025.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    var window: UIWindow
    var navigationController: UINavigationController
    var tabBarController: UITabBarController
    var localStorageManager: LocalStorageManager
    
    private var usersCoordinator: UserListCoordinator!
    private var bookmarksCoordinator: BookmarksCoordinator!
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        self.tabBarController = UITabBarController()
        self.localStorageManager = LocalStorageManager()
        
    }
    
    func start() {
        let usersNav = UINavigationController()
        usersCoordinator = UserListCoordinator(navigationController: usersNav, localStorageManager: localStorageManager)
        usersCoordinator.start()
        usersNav.tabBarItem = UITabBarItem(
            title: "Users",
            image: UIImage(systemName: "person.3"),
            selectedImage: UIImage(systemName: "person.3.fill")
        )

        let bookmarksNav = UINavigationController()
        bookmarksCoordinator = BookmarksCoordinator(navigationController: bookmarksNav, localStorageManager: localStorageManager)
        bookmarksCoordinator.start()
        bookmarksNav.tabBarItem = UITabBarItem(
            title: "Bookmarks",
            image: UIImage(systemName: "bookmark"),
            selectedImage: UIImage(systemName: "bookmark.fill")
        )

        let tabBar = tabBarController.tabBar
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()

        appearance.backgroundEffect = UIBlurEffect(style: .systemMaterial)
        appearance.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.8)

        tabBar.layer.cornerRadius = 16
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBar.layer.masksToBounds = true

        tabBar.tintColor = UIColor.systemBlue
        tabBar.unselectedItemTintColor = UIColor.systemGray

        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.1
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
        tabBar.layer.shadowRadius = 6
        tabBar.layer.masksToBounds = false

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance

        tabBarController.viewControllers = [usersNav, bookmarksNav]
        tabBarController.tabBar.itemPositioning = .automatic
        tabBarController.tabBar.isTranslucent = true
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }

}
