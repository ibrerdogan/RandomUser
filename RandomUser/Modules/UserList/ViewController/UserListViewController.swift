//
//  UserListViewController.swift
//  RandomUser
//
//  Created by İbrahim Erdogan on 2.10.2025.
//

import UIKit

final class UserListViewController: UIViewController {
    var viewModel = UserListViewModel(apiClient: APIClient.shared)
    
    private lazy var userListTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UserCell.self, forCellReuseIdentifier: "UserCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        searchBar.placeholder = "Search users by name"
        return searchBar
    }()
    
    private lazy var footerActivityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.frame = CGRect(x: 0, y: 0, width: userListTableView.bounds.width, height: 44)
        indicator.hidesWhenStopped = true
        return indicator
    }()
   
    override func viewDidLoad() {
        title = "User List"
        view.backgroundColor = .white
        viewModel.delegate = self
        viewModel.fetchUsers()
        view.addSubview(searchBar)
        view.addSubview(userListTableView)
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            userListTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            userListTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            userListTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            userListTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func loadMoreUsers() {
        guard viewModel.checkCanLoadMore() else {return}
        userListTableView.tableFooterView = footerActivityIndicator
        footerActivityIndicator.startAnimating()
        viewModel.loadMoreUsers()
    }
    
}
extension UserListViewController: UserListViewModelProtocol {
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
            }
        }
    }
    
    func updateList(with users: [User]) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.userListTableView.reloadData()
        }
    }
    
    
}

extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getUserCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = userListTableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserCell {
            cell.configure(with: viewModel.getUser(for: indexPath))
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
       
    }
    
    
}

extension UserListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       // isSearching = !searchText.isEmpty
       // if isSearching {
       //     filteredUsers = users.filter {
       //         ($0.name.first + " " + $0.name.last)
       //             .lowercased()
       //             .contains(searchText.lowercased())
       //     }
       // } else {
       //     filteredUsers = users
       // }
       // tableView.reloadData()
    }
}


final class UserCell: UITableViewCell {
    
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stack = UIStackView(arrangedSubviews: [nameLabel, emailLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        emailLabel.font = UIFont.systemFont(ofSize: 14)
        emailLabel.textColor = .secondaryLabel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with user: User) {
        nameLabel.text = "\(user.name.first) \(user.name.last)"
        emailLabel.text = user.email
    }
}
