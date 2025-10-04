//
//  ContactCardView.swift
//  RandomUser
//
//  Created by İbrahim Erdogan on 4.10.2025.
//

import Foundation
import UIKit
final class ContactCardView: UIView {
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 14
        view.layer.masksToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowRadius = 6
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        return view
    }()
    
    private lazy var rowsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    init(user: User) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupViews()
        
        let emailRow = InfoRowView(iconSystemName: "envelope", title: "Email", detail: user.email, showsSeparator: true)
        let phoneRow = InfoRowView(iconSystemName: "phone", title: "Phone", detail: user.cell, showsSeparator: false)
        rowsStack.addArrangedSubview(emailRow)
        rowsStack.addArrangedSubview(phoneRow)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupViews() {
        addSubview(cardView)
        cardView.addSubview(rowsStack)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: topAnchor),
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            rowsStack.topAnchor.constraint(equalTo: cardView.topAnchor),
            rowsStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            rowsStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            rowsStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor)
        ])
    }
}
