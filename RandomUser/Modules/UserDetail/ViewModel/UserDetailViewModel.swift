//
//  UserDetailViewModel.swift
//  RandomUser
//
//  Created by İbrahim Erdogan on 4.10.2025.
//

import Foundation

final class UserDetailViewModel {
    private var localStorageManager: LocalStorageManager
    var user: User
    
    init(user: User, localStorageManager: LocalStorageManager) {
        self.user = user
        self.localStorageManager = localStorageManager
    }
    
    func createCoordinaate() -> (Double?, Double?) {
        guard let latitude = Double(user.location.coordinates.latitude), let longitude = Double(user.location.coordinates.longitude) else
        {return (nil, nil)}
        return (latitude, longitude)
    }
    
    func isBookmarked() -> Bool {
        localStorageManager.userExists(for: user)
    }
    
    func manageBookmark() {
        localStorageManager.manageUserBookMark(for: user)
    }
}
