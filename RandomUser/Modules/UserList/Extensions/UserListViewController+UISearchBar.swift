//
//  UserListViewController+UISearchBar.swift
//  RandomUser
//
//  Created by İbrahim Erdogan on 5.10.2025.
//

import Foundation
import UIKit

extension UserListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.setMakingSearch(isSearching: !searchText.isEmpty)
        if viewModel.searchgingIsProgress() {
            viewModel.searchForName(for: searchText)
        }
    }
}
