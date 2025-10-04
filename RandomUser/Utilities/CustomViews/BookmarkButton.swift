//
//  BookmarkButton.swift
//  RandomUser
//
//  Created by İbrahim Erdogan on 4.10.2025.
//

import Foundation
import UIKit

final class BookmarkButton: UIButton {
    
    // MARK: - Properties
    var isBookmarked: Bool = false {
        didSet {
            updateAppearance()
        }
    }
    
    var onTap: ((Bool) -> Void)?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    convenience init(isBookmarked: Bool = false) {
        self.init(frame: .zero)
        self.isBookmarked = isBookmarked
        updateAppearance()
    }
    
    // MARK: - Setup
    private func setupButton() {
        tintColor = .gray
        addTarget(self, action: #selector(bookmarkTapped), for: .touchUpInside)
        updateAppearance()
    }
    
    private func updateAppearance() {
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        let iconName = isBookmarked ? "bookmark.fill" : "bookmark"
        let image = UIImage(systemName: iconName, withConfiguration: config)
        setImage(image, for: .normal)
    }
    
    @objc private func bookmarkTapped() {
        isBookmarked.toggle()
        onTap?(isBookmarked)
        
        // Animasyon eklemek isterseniz
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.transform = .identity
            }
        }
    }
    
    // MARK: - Public Methods
    func configure(isBookmarked: Bool) {
        self.isBookmarked = isBookmarked
    }
}
