//
//  UserDetailViewModel.swift
//  RandomUser
//
//  Created by İbrahim Erdogan on 4.10.2025.
//

import Foundation
import CoreLocation

final class UserDetailViewModel {
    private var localStorageManager: LocalStorageManager
    private(set) var user: User
    
    var coordinate: CLLocationCoordinate2D? {
            guard let lat = Double(user.location.coordinates.latitude),
                  let lon = Double(user.location.coordinates.longitude) else { return nil }
            return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }
    
    init(user: User, localStorageManager: LocalStorageManager) {
        self.user = user
        self.localStorageManager = localStorageManager
    }
    
    func createCoordinaate() -> (Double?, Double?) {
        guard let latitude = Double(user.location.coordinates.latitude), let longitude = Double(user.location.coordinates.longitude) else
        {return (nil, nil)}
        return (latitude, longitude)
    }
    
    func getUser() -> User {
        user
    }
    
    func isBookmarked() -> Bool {
        localStorageManager.userExists(for: user)
    }
    
    func toggleBookmark() {
        localStorageManager.manageUserBookMark(for: user)
    }
}
