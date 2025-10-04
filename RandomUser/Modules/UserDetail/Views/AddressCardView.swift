//
//  AddressCardView.swift
//  RandomUser
//
//  Created by İbrahim Erdogan on 4.10.2025.
//

import Foundation
import UIKit
final class AddressCardView: UIView {
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
    
    init(with user: User) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupViews(user: user)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupViews(user: User) {
        addSubview(cardView)
        let addressRow = InfoRowView(iconSystemName: "mappin.and.ellipse",
                                     title: "Address",
                                     detail: createAddress(for: user),
                                     showsSeparator: false)
        addressRow.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(addressRow)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: topAnchor),
            cardView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            addressRow.topAnchor.constraint(equalTo: cardView.topAnchor),
            addressRow.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            addressRow.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            addressRow.bottomAnchor.constraint(equalTo: cardView.bottomAnchor)
        ])
    }
    
    private func createAddress(for user: User) -> String {
        return "\(user.location.country), \(user.location.state), \(user.location.city), \(user.location.street.name), \(user.location.street.number)"
    }
}
