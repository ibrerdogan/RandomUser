//
//  BookmarksViewModel.swift
//  RandomUser
//
//  Created by İbrahim Erdogan on 4.10.2025.
//

import Foundation
protocol BookmarksViewModelProtocol: AnyObject {
    func updateUI()
}
final class BookmarksViewModel {
    weak var coordinator: BookmarksCoordinator?
    weak var delegate: BookmarksViewModelProtocol?
    private var localStorageManager: LocalStorageManager
    init(localStorageManager: LocalStorageManager) {
        self.localStorageManager = localStorageManager
        localStorageManager.delegate = self
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

extension BookmarksViewModel: LocalStorageProtocol {
    func changed() {
        delegate?.updateUI()
    }
}
