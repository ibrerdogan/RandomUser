//
//  InfoRowView.swift
//  RandomUser
//
//  Created by İbrahim Erdogan on 4.10.2025.
//

import Foundation
import UIKit

final class InfoRowView: UIView {
    private let iconContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.backgroundColor = UIColor(red: 235/255, green: 245/255, blue: 255/255, alpha: 1) // hafif mavi
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(red: 35/255, green: 100/255, blue: 220/255, alpha: 1)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(white: 0.4, alpha: 1)
        return label
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor(white: 0.07, alpha: 1)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var labelsStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, detailLabel])
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.alignment = .leading
        return stackView
    }()
    
    private lazy var mainStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [iconContainer, labelsStack])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(iconSystemName: String, title: String, detail: String, showsSeparator: Bool = true) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupViews()
        configure(iconSystemName: iconSystemName, title: title, detail: detail, showsSeparator: showsSeparator)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }
    
    private func setupViews() {
        addSubview(mainStack)
        iconContainer.addSubview(iconImageView)
        addSubview(separator)
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            
            iconContainer.widthAnchor.constraint(equalToConstant: 40),
            iconContainer.heightAnchor.constraint(equalToConstant: 40),
            
            iconImageView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    func configure(iconSystemName: String, title: String, detail: String, showsSeparator: Bool = true) {
        iconImageView.image = UIImage(systemName: iconSystemName)
        titleLabel.text = title
        detailLabel.text = detail
        separator.isHidden = !showsSeparator
    }
}
