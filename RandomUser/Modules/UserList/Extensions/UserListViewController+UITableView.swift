//
//  UserListViewController+UITableView.swift
//  RandomUser
//
//  Created by İbrahim Erdogan on 5.10.2025.
//

import Foundation
import UIKit
extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getUserCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = userListTableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserCell {
            cell.configure(with: viewModel.getUser(for: indexPath),bookmarked: viewModel.isBookmarked(for: indexPath))
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = viewModel.getUserCount() - 1
        
        if indexPath.row >= lastRowIndex - 3 {
            loadMoreUsers()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.coordinator?.showUserDetail(with: viewModel.getUser(for: indexPath))
    }
    
    
}
