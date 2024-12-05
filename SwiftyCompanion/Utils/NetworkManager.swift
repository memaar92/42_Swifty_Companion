//
//  NetworkManager.swift
//  SwiftyCompanion
//
//  Created by Marius Messerschmied on 27.11.24.
//

import SwiftUI

struct NetworkManager {

    func makeAuthorizedGetRequest<T: Decodable>(url: URL) async throws -> (T, HTTPURLResponse) {
        let request = try await createAuthorizedGetRequest(from: url)
       
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard ((response as? HTTPURLResponse)?.statusCode != nil) else {
            throw NetworkError.noResponse
        }
        
        if let response = response as? HTTPURLResponse, response.statusCode == 401 {
            // usually here we would retry if we have a refresh token
            throw AuthError.invalidAccessToken
        }
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.unsuccessfulResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return (try decoder.decode(T.self, from: data), response)
        } catch {
            throw NetworkError.responseNotDecodable
        }
        
    }

    private func createAuthorizedGetRequest(from url: URL) async throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let accessToken = try await AuthManager.shared.getToken()
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        return request
    }
    
}
