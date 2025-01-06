//
//  MockNetworkManager.swift
//  SwiftyCompanionTests
//
//  Created by Marius Messerschmied on 21.12.24.
//

import SwiftUI
@testable import SwiftyCompanion

enum MockNetworkError: Error {
    case typeMismatch(description: String)
}

struct MockNetworkManager: NetworkManagerProtocol {
    var mockResponse: ([Peer], HTTPURLResponse) = ([], HTTPURLResponse())
    var errorToThrow: Error? = nil
    
    func makeAuthorizedGetRequest<T: Decodable>(url: URL) async throws -> (T, HTTPURLResponse) {
        if let error = errorToThrow {
            throw error
        }
        
        guard let response = mockResponse.0 as? T else {
            throw MockNetworkError.typeMismatch(description: "Type mismatch. Please provide valid test data")
            // may replace with throw NetworkError.responseNotDecodable
        }
        return (response, mockResponse.1)
    }
}
