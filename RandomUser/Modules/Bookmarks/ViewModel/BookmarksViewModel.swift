//
//  BookmarksViewModel.swift
//  RandomUser
//
//  Created by İbrahim Erdogan on 4.10.2025.
//

import Foundation

final class BookmarksViewModel {
    private var localStorageManager: LocalStorageManager
    init(localStorageManager: LocalStorageManager) {
        self.localStorageManager = localStorageManager
    }
    
    func getUserCount() -> Int {
        localStorageManager.getUsers().count
    }
    
    func getUser(for indexPath: IndexPath) -> User{
        localStorageManager.getUsers()[indexPath.row]
    }
    
    func manageUserBookMark(for user: User) {
        localStorageManager.manageUserBookMark(for: user)
    }
    
    
}
