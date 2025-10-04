//
//  UserDetailViewModel.swift
//  RandomUser
//
//  Created by İbrahim Erdogan on 4.10.2025.
//

import Foundation

final class UserDetailViewModel {
    var user: User
    
    init(user: User) {
        self.user = user
    }
    
    func createCoordinaate() -> (Double?, Double?) {
        guard let latitude = Double(user.location.coordinates.latitude), let longitude = Double(user.location.coordinates.longitude) else
        {return (nil, nil)}
        return (latitude, longitude)
    }
}
