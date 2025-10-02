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
    
    // Child coordinators
    private var usersCoordinator: UserListCoordinator!
    private var bookmarksCoordinator: BookmarksCoordinator!
    
    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
        self.tabBarController = UITabBarController()
    }
    
    func start() {
        // Users flow
        let usersNav = UINavigationController()
        usersCoordinator = UserListCoordinator(navigationController: usersNav)
        usersCoordinator.start()
        usersNav.tabBarItem = UITabBarItem(title: "Users", image: UIImage(systemName: "person.3"), tag: 0)
        
        // Bookmarks flow
        let bookmarksNav = UINavigationController()
        bookmarksCoordinator = BookmarksCoordinator(navigationController: bookmarksNav)
        bookmarksCoordinator.start()
        bookmarksNav.tabBarItem = UITabBarItem(title: "Bookmarks", image: UIImage(systemName: "bookmark"), tag: 1)
        
        // Setup TabBar
        tabBarController.viewControllers = [usersNav, bookmarksNav]
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}
