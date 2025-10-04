//
//  UserDetailViewController.swift
//  RandomUser
//
//  Created by İbrahim Erdogan on 2.10.2025.
//

import UIKit

final class UserDetailViewController: UIViewController {
    var viewModel: UserDetailViewModel
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var contentStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 18
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var headerView: ProfileHeaderView = {
        let headerView = ProfileHeaderView(user: viewModel.user)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        return headerView
    }()
    
    private lazy var contactTitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Contact Information"
        l.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        l.textColor = UIColor(white: 0.25, alpha: 1)
        return l
    }()
    
    private lazy var contactCard: ContactCardView = {
        let contactCard = ContactCardView(user: viewModel.user)
        contactCard.translatesAutoresizingMaskIntoConstraints = false
        return contactCard
    }()
    
    private lazy var addressTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Address"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = UIColor(white: 0.25, alpha: 1)
        return label
    }()
    
    private lazy var addressCard: AddressCardView = {
        let addressView = AddressCardView(with: viewModel.user)
        addressView.translatesAutoresizingMaskIntoConstraints = false
        return addressView
    }()
    
    private lazy var mapViewContainer: MapViewContainer = {
        let mapView = MapViewContainer()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    // MARK: - Init
    init(viewModel: UserDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        guard let latitude = viewModel.createCoordinaate().0, let longitude = viewModel.createCoordinaate().1 else {return}
        mapViewContainer.configure(latitude: latitude,
                                   longitude: longitude)
    }
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 245/255, green: 246/255, blue: 248/255, alpha: 1) 
        setupScrollAndStack()
        populateStack()
    }
    
    private func setupScrollAndStack() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(contentStack)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor), 
            
            contentStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }
    
    private func populateStack() {
        contentStack.addArrangedSubview(headerView)
        
        contentStack.addArrangedSubview(contactTitleLabel)
        contentStack.addArrangedSubview(contactCard)
        
        contentStack.addArrangedSubview(addressTitleLabel)
        contentStack.addArrangedSubview(addressCard)
        
        contentStack.addArrangedSubview(mapViewContainer)
        
    }

}
