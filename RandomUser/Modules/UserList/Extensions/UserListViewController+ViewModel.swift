//
//  UserListViewController+ViewModel.swift
//  RandomUser
//
//  Created by İbrahim Erdogan on 5.10.2025.
//

import Foundation
extension UserListViewController: UserListViewModelProtocol {
    
    func changedUserBookmarkStatus(for user: User, in indexPath: IndexPath) {
        if let cell = userListTableView.cellForRow(at: indexPath) as? UserCell {
            cell.configure(with: user, bookmarked: viewModel.isBookmarked(for: indexPath))
        }
    }
    
    func addNewUsers(with newUsers: [User]) {
        let startIndex = viewModel.getUserCount() - newUsers.count
        let endIndex = viewModel.getUserCount() - 1
        
        var indexPaths: [IndexPath] = []
        for index in startIndex...endIndex {
            indexPaths.append(IndexPath(row: index, section: 0))
        }
        
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            strongSelf.userListTableView.performBatchUpdates({
                strongSelf.userListTableView.insertRows(at: indexPaths, with: .automatic)
            }) {[weak self] status in
                guard let strongSelf = self else {return}
                strongSelf.viewModel.completedLoadingMore()
                strongSelf.footerActivityIndicator.stopAnimating()
            }
        }
    }
    
    func updateList(with users: [User]) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.userListTableView.reloadData()
            strongSelf.activityIndicator.stopAnimating()
        }
    }
    
    
}
