//
//  LocalStorageManager.swift
//  RandomUser
//
//  Created by İbrahim Erdogan on 4.10.2025.
//

import Foundation

protocol LocalStorageProtocol: AnyObject {
    func changed()
}

final class LocalStorageManager {
    private let userDefaults = UserDefaults.standard
    private let usersKey = "SavedUsers"
    weak var delegate: LocalStorageProtocol?
    func manageUserBookMark(for user: User) {
        if userExists(for: user) {
            removeUser(user)
        } else {
            addUser(user)
        }
        delegate?.changed()
            
    }
    
    func getUsers() -> [User] {
        guard let data = userDefaults.data(forKey: usersKey) else {
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            let users = try decoder.decode([User].self, from: data)
            return users
        } catch {
            print("Failed to load users: \(error.localizedDescription)")
            return []
        }
    }
    
    private func saveUsers(_ users: [User]) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(users)
            userDefaults.set(data, forKey: usersKey)
            userDefaults.synchronize()
        } catch {
            print("Failed to save users: \(error.localizedDescription)")
        }
    }
    
    private func addUser(_ user: User) {
        var users = getUsers()
        users.append(user)
        saveUsers(users)
    }
    
    private func removeUser(_ user: User) {
        var users = getUsers()
        users.removeAll(where: {$0.login.uuid == user.login.uuid})
        saveUsers(users)
    }
    
    private func clearAllUsers() {
        userDefaults.removeObject(forKey: usersKey)
        userDefaults.synchronize()
    }
    
    func userExists(for user: User) -> Bool {
        let users = getUsers()
        return users.contains(where: { $0.login.uuid == user.login.uuid })
    }
}
