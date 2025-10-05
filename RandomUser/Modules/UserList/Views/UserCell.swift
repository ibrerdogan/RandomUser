//
//  UserCell.swift
//  RandomUser
//
//  Created by İbrahim Erdogan on 5.10.2025.
//

import Foundation
import UIKit

protocol UserCellProtocol:AnyObject {
    func bookmarkTapped(for user: User)
}

class UserCell: UITableViewCell {
    weak var delegate: UserCellProtocol?
    private var user: User?
    private var isBookmarked: Bool = false
    private lazy var containerView: UIView = {
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
    
    private lazy var avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 25
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .darkGray
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var bookmarkButton: BookmarkButton = {
        let button = BookmarkButton()
        button.translatesAutoresizingMaskIntoConstraints = false
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
        bookmarkButton.onTap = { [weak self] isBookmarked in
            guard let strongSelf = self else {return}
            strongSelf.bookmarkTapped()
        }
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
        bookmarkButton.configure(isBookmarked: isBookmarked)
    }
    
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
