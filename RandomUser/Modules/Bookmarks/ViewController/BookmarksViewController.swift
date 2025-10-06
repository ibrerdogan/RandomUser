//
//  BookmarksViewController.swift
//  RandomUser
//
//  Created by İbrahim Erdogan on 2.10.2025.
//

import UIKit

final class BookmarksViewController: UIViewController {
    weak var coordinator: BookmarksCoordinator?
    var viewModel: BookmarksViewModel
    
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
    
    private lazy var noBookmarkPersonImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "noBookmarkedImage"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    init(coordinator: BookmarksCoordinator? = nil, viewModel: BookmarksViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
        handleNoBookmarkedUserImageView(isHidden: false)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        title = "Bookmarks"
        view.backgroundColor = .white
        view.addSubviews([userListTableView, noBookmarkPersonImage])
        userListTableView.reloadData()
        NSLayoutConstraint.activate([
            
            noBookmarkPersonImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            noBookmarkPersonImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            noBookmarkPersonImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            noBookmarkPersonImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            
            userListTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            userListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userListTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async {[weak self] in
            guard let strongSelf = self else {return}
            strongSelf.userListTableView.reloadData()
            strongSelf.checkBookmarkedUserCount()
        }
    }
    
    private func checkBookmarkedUserCount() {
        handleNoBookmarkedUserImageView(isHidden: !(viewModel.getUserCount() == 0))
    }
    
    private func handleNoBookmarkedUserImageView(isHidden: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.noBookmarkPersonImage.isHidden = isHidden
            strongSelf.userListTableView.isHidden = !isHidden
        }
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
        reloadTableView()
    }
}

extension BookmarksViewController: BookmarksViewModelProtocol {
    func updateUI() {
        reloadTableView()
    }
}
