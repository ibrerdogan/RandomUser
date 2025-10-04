//
//  BookmarksViewController.swift
//  RandomUser
//
//  Created by İbrahim Erdogan on 2.10.2025.
//

import UIKit

final class BookmarksViewController: UIViewController {
    weak var coordinator: BookmarksCoordinator?
    private var viewModel: BookmarksViewModel
    
    private lazy var userListTableView: UITableView = {
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
    
    init(coordinator: BookmarksCoordinator? = nil, viewModel: BookmarksViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        title = "Bookmarks"
        view.backgroundColor = .white
        view.addSubview(userListTableView)
        userListTableView.reloadData()
        NSLayoutConstraint.activate([
            userListTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            userListTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            userListTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            userListTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension BookmarksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getUserCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = userListTableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserCell {
            cell.configure(with: viewModel.getUser(for: indexPath),bookmarked: true)
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.showUserDetail(user: viewModel.getUser(for: indexPath))
    }
    
}

extension BookmarksViewController: UserCellProtocol {
    func bookmarkTapped(for user: User) {
        viewModel.manageUserBookMark(for: user)
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            strongSelf.userListTableView.reloadData()
        }
    }
}
