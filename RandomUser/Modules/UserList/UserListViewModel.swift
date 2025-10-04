//
//  UserListViewModel.swift
//  RandomUser
//
//  Created by İbrahim Erdogan on 3.10.2025.
//

import Foundation
protocol UserListViewModelProtocol: AnyObject {
    func updateList(with users: [User])
}
final class UserListViewModel {
    private var apiClient: APIClient
    weak var delegate: UserListViewModelProtocol?
    weak var coordinator: UserListCoordinator?
    var users = [User]()
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func fetchUsers(for page: Int) {
        apiClient.request(endpoint: .randomUsers(page: page)) { [weak self] (result: Result<RandomUserResponseModel, Error>) in
            guard let strongSelf = self else {return}
            switch result {
            case .success(let response):
                strongSelf.delegate?.updateList(with: response.results)
                strongSelf.users = response.results
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
