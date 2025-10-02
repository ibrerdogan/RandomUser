//
//  BookmarksViewController.swift
//  RandomUser
//
//  Created by İbrahim Erdogan on 2.10.2025.
//

import UIKit

final class BookmarksViewController: UIViewController {
    weak var coordinator: BookmarksCoordinator?
    
    private lazy var detailButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Gooo", for: .normal)
        button.titleLabel?.textColor = .black
        button.addTarget(self, action: #selector(goToDetails), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        view.addSubview(detailButton)
        NSLayoutConstraint.activate([
            detailButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            detailButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
    }
    
    @objc
    func goToDetails() {
        coordinator?.showUserDetail()
    }
}
