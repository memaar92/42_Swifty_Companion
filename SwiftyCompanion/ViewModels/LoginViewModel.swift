//
//  LoginViewModel.swift
//  SwiftyCompanion
//
//  Created by Marius Messerschmied on 24.11.24.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    
    var url42Auth: URL {
        let clientID = ProcessInfo.processInfo.environment["clientID"] ?? ""
        let url = "https://api.intra.42.fr/oauth/authorize?client_id=" + clientID + "&redirect_uri=swiftyapp%3A%2F%2Foauth-callback&response_type=code"
        return URL(string: url)!
    }
    
    let callBackScheme: String = "swiftyapp"
    
    func authWith42(callbackURL: URL) async throws {
        let queryItems = URLComponents(string: callbackURL.absoluteString)?.queryItems
        guard let code = queryItems?.filter({ $0.name == "code" }).first?.value else {
            throw AuthError.missingAuthCode
        }
        try await createToken(code: code)
    }
    
    
    func createToken(code: String) async throws {
        let url = URL(string: "https://api.intra.42.fr/oauth/token")!
        let requestBodyData = AuthCodeData(code: code,
                                client_id: ProcessInfo.processInfo.environment["clientID"] ?? "",
                                client_secret: ProcessInfo.processInfo.environment["clientSecret"] ?? "",
                                grant_type: "authorization_code",
                                redirect_uri: "swiftyapp://oauth-callback")
        
        
        let jsonData = try JSONEncoder().encode(requestBodyData)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            throw NetworkError.noResponse
        }
        
        guard (200...299).contains(statusCode) else {
            throw NetworkError.unsuccessfulResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let token = try decoder.decode(Token.self, from: data)
            try await AuthManager.shared.storeTokenOnKeychain(token: token)
        } catch AuthError.tokenAlreadyStored {
            // do nothing; this case should not occur due to the checkToken in HomeView
            print("Token already stored")
        } catch {
            throw AuthError.missingAccessToken
        }
    }
    
}
