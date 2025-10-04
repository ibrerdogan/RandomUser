//
//  UserListViewController.swift
//  RandomUser
//
//  Created by İbrahim Erdogan on 2.10.2025.
//

import UIKit

final class UserListViewController: UIViewController {
    var viewModel = UserListViewModel(apiClient: APIClient.shared, localStorageManager: LocalStorageManager())
    
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

extension UserListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.setMakingSearch(isSearching: !searchText.isEmpty)
        if viewModel.searchgingIsProgress() {
            viewModel.searchForName(for: searchText)
        }
    }
}

extension UserListViewController: UserCellProtocol {
    func bookmarkTapped(for user: User) {
        viewModel.manageUserBookMark(for: user)
    }
}

protocol UserCellProtocol:AnyObject {
    func bookmarkTapped(for user: User)
}

class UserCell: UITableViewCell {
    weak var delegate: UserCellProtocol?
    private var user: User?
    private var isBookmarked: Bool = false
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 25
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .darkGray
        label.numberOfLines = 1
        return label
    }()
    
    private let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        let image = UIImage(systemName: "bookmark", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(bookmarkTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var textStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nameLabel, usernameLabel])
        stack.axis = .vertical
        stack.spacing = 2
        return stack
    }()
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [avatarImageView, textStack, bookmarkButton])
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
           
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            mainStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            mainStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            mainStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            mainStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            
            avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            avatarImageView.heightAnchor.constraint(equalToConstant: 50),
            
            bookmarkButton.widthAnchor.constraint(equalToConstant: 30),
            bookmarkButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func configure(with user: User, bookmarked: Bool) {
        self.user = user
        self.isBookmarked = bookmarked
        nameLabel.text = user.name.first
        usernameLabel.text = "@\(user.login.username)"
        loadImage(from: user.picture.medium)
        configureBookmarkButton()
    }
    
    @objc
    func bookmarkTapped() {
        guard let user = user else {return}
        delegate?.bookmarkTapped(for: user)
        isBookmarked.toggle()
        configureBookmarkButton()
    }
    
    private func configureBookmarkButton() {
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        let iconName = isBookmarked ? "bookmark.fill" : "bookmark"
        let image = UIImage(systemName: iconName, withConfiguration: config)
        bookmarkButton.setImage(image, for: .normal)
    }
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async {
                self?.avatarImageView.image = UIImage(data: data)
            }
        }.resume()
    }
}
