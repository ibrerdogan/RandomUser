//
//  UserListViewController.swift
//  RandomUser
//
//  Created by İbrahim Erdogan on 2.10.2025.
//

import UIKit

final class UserListViewController: UIViewController {
    var viewModel: UserListViewModel
    
    lazy var userListTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UserCell.self, forCellReuseIdentifier: "UserCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.tintColor = .gray
        return indicator
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        searchBar.placeholder = "Search users by name"
        return searchBar
    }()
    
    lazy var footerActivityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.frame = CGRect(x: 0, y: 0, width: userListTableView.bounds.width, height: 44)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    init(viewModel: UserListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        configureView()
        activityIndicator.startAnimating()
        Task{
            await viewModel.fetchUsers()
        }
        addComponents()
        configureLayout()
       
    }
    
    private func addComponents() {
        view.addSubviews([searchBar, userListTableView, activityIndicator])
    }
    
    private func configureLayout() {
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
    
    private func configureView() {
        title = "User List"
        view.backgroundColor = .white
    }
    
    func loadMoreUsers() {
        guard viewModel.checkCanLoadMore() else {return}
        userListTableView.tableFooterView = footerActivityIndicator
        footerActivityIndicator.startAnimating()
        Task {
            await viewModel.loadMoreUsers()
        }
    }
    
}
