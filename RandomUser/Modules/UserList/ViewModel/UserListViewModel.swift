//
//  UserListViewModel.swift
//  RandomUser
//
//  Created by İbrahim Erdogan on 3.10.2025.
//

import Foundation
protocol UserListViewModelProtocol: AnyObject {
    func updateList(with users: [User])
    func addNewUsers(with newUsers: [User])
}
final class UserListViewModel {
    private var apiClient: APIClient
    private var localStorageManager: LocalStorageManager
    private var users = [User]()
    private var filteredUsers = [User]()
    private var currentPage: Int = 1
    private var loadingMore: Bool = false
    
    weak var delegate: UserListViewModelProtocol?
    weak var coordinator: UserListCoordinator?
    private var isSearching: Bool = false
    
    
    init(apiClient: APIClient, localStorageManager: LocalStorageManager) {
        self.apiClient = apiClient
        self.localStorageManager = localStorageManager
    }
    
    func fetchUsers() {
        debugPrint("fetching")
        apiClient.request(endpoint: .randomUsers(page: currentPage)) { [weak self] (result: Result<RandomUserResponseModel, Error>) in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let response):
                strongSelf.updateView(with: response.results)
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    private func updateView(with users: [User]) {
        self.users.append(contentsOf: users)
        if currentPage == 1 {
            delegate?.updateList(with: users)
        } else {
            delegate?.addNewUsers(with: users)
        }
        currentPage += 1
        
    }
    
    func checkCanLoadMore() -> Bool {
        !loadingMore && !isSearching
    }
    
    func completedLoadingMore() {
        loadingMore = false
    }
    
    func loadMoreUsers() {
        loadingMore = true
        fetchUsers()
        
    }
    
    func getUserCount() -> Int {
        isSearching ? filteredUsers.count : users.count
    }
    
    func getUser(for indexPath: IndexPath) -> User {
        isSearching ? filteredUsers[indexPath.row] :  users[indexPath.row]
    }
    
    func setMakingSearch(isSearching: Bool) {
        if !isSearching {
            filteredUsers.removeAll()
            delegate?.updateList(with: users)
        }
        self.isSearching = isSearching
    }
    
    func searchgingIsProgress() -> Bool {
        isSearching
    }
    
    func searchForName(for searchText: String) {
        filteredUsers = users.filter {
            ($0.name.first + " " + $0.name.last)
                .lowercased()
                .contains(searchText.lowercased())
        }
        delegate?.updateList(with: filteredUsers)
    }
    
    func manageUserBookMark(for user: User) {
        localStorageManager.manageUserBookMark(for: user)
    }
    
    func isBookmarked(for indexPath: IndexPath) -> Bool {
        localStorageManager.userExists(for: isSearching ? filteredUsers[indexPath.row] :  users[indexPath.row])
    }
}
