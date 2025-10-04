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
    private var users = [User]()
    private var currentPage: Int = 1
    private var loadingMore: Bool = false
    weak var delegate: UserListViewModelProtocol?
    weak var coordinator: UserListCoordinator?
    
    
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
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
        !loadingMore
    }
    
    func completedLoadingMore() {
        loadingMore = false
    }
    
    func loadMoreUsers() {
        loadingMore = true
        fetchUsers()
        
    }
    
    func getUserCount() -> Int {
        users.count
    }
    
    func getUser(for indexPath: IndexPath) -> User {
        users[indexPath.row]
    }
}
