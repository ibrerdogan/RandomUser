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
        usersNav.tabBarItem = UITabBarItem(title: "Users", image: UIImage(systemName: "person.3"), tag: 0)
        
        let bookmarksNav = UINavigationController()
        bookmarksCoordinator = BookmarksCoordinator(navigationController: bookmarksNav,localStorageManager: localStorageManager)
        bookmarksCoordinator.start()
        bookmarksNav.tabBarItem = UITabBarItem(title: "Bookmarks", image: UIImage(systemName: "bookmark"), tag: 1)
        
        tabBarController.viewControllers = [usersNav, bookmarksNav]
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}
