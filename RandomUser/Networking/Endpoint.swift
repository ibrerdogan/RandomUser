//
//  Endpoint.swift
//  RandomUser
//
//  Created by İbrahim Erdogan on 2.10.2025.
//

import Foundation

enum Endpoint {
    case randomUsers(page: Int, results: Int = 25)
    
    var url: URL? {
        switch self {
        case .randomUsers(let page, let results):
            var components = URLComponents(string: "https://randomuser.me/api/")
            components?.queryItems = [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "results", value: "\(results)")
            ]
            return components?.url
        }
    }
}
