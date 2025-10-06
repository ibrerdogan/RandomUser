//
//  APIClient.swift
//  RandomUser
//
//  Created by İbrahim Erdogan on 2.10.2025.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case noData
    case decodingError(Error)
    case networkError(Error)
}

final class APIClient {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<T: Decodable>(endpoint: Endpoint) async throws -> T {
        guard let url = endpoint.url else {
            throw APIError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw APIError.invalidResponse
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            return try decoder.decode(T.self, from: data)
        } catch let decodingError as DecodingError {
            throw APIError.decodingError(decodingError)
        } catch {
            throw APIError.networkError(error)
        }
    }
}
