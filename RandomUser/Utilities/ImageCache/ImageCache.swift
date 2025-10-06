//
//  ImageCache.swift
//  RandomUser
//
//  Created by İbrahim Erdogan on 6.10.2025.
//

import Foundation
import UIKit

final class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSURL, UIImage>()
    
    private let placeholderImage: UIImage = {
        let config = UIImage.SymbolConfiguration(pointSize: 40, weight: .light)
        return UIImage(systemName: "person.circle.fill", withConfiguration: config) ?? UIImage()
    }()

    private init() {}

    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        if let cached = cache.object(forKey: url as NSURL) {
            completion(cached)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  error == nil,
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(self.placeholderImage)
                }
                return
            }
            
            self.cache.setObject(image, forKey: url as NSURL)
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
