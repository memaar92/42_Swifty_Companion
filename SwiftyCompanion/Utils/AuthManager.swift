//
//  AuthManager.swift
//  SwiftyCompanion
//
//  Created by Marius Messerschmied on 27.11.24.
//

import SwiftUI
import Security

actor AuthManager: ObservableObject {
    static let shared = AuthManager()
    private init() {}
    
    @MainActor
    @Published public var isLoggedIn: Bool = false
    
    private var refreshTask: Task<String, Error>?
    
    func checkToken() async throws {
        do {
            _ = try await getToken()
            await updateLoginState(newState: true)
        } catch {
            await updateLoginState(newState: false)
        }
    }
    
    func getToken() async throws -> String {
        
        if let refreshTask {
            return try await refreshTask.value
        }
        
        let (accessToken, tokenExpiration) = try await getTokenFromKeychain()
        
        if Double(tokenExpiration)! > Date().timeIntervalSince1970 {
            await updateLoginState(newState: true)
            return accessToken
        }
        
        return try await refreshToken()
    }
    
    
    func refreshToken() async throws -> String {
        
        if let refreshTask {
            return try await refreshTask.value
        }
        
        let task = Task { () throws -> String in
            defer { refreshTask = nil }
            
            // 42 API doesn't issue a refreshToken
            // Hence we will delete the exisiting token and send the user back to the login view
            try await deleteTokenOnKeychain()
            throw AuthError.invalidRefreshToken
        }
        
        self.refreshTask = task
        return try await task.value
    }
    
    
    func getTokenFromKeychain() async throws -> (String, String) {
        let tag = "swiftyapp-token"
        let getquery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                       kSecAttrAccount as String: tag,
                                       //kSecAttrGeneric as String: true,
                                       kSecReturnData as String: true,
                                       kSecReturnAttributes as String: true,
                                       kSecMatchLimit as String: kSecMatchLimitOne]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(getquery as CFDictionary, &item)
        guard status == errSecSuccess else {
            throw AuthError.missingAccessToken
        }
        
        guard let existingItem = item as? [String : Any],
              let expirationDateTimestamp = existingItem[kSecAttrGeneric as String] as? Data,
              let expirationDate = String(data: expirationDateTimestamp, encoding: .utf8),
              let tokenData = existingItem[kSecValueData as String] as? Data,
              let accessToken = String(data: tokenData, encoding: .utf8) else {
            throw AuthError.missingAccessToken
        }
        return (accessToken, expirationDate)
    }
    
    func deleteTokenOnKeychain() async throws {
        let tag = "swiftyapp-token"
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: tag,
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        await updateLoginState(newState: false)
        
        guard status == errSecSuccess else {
            throw AuthError.failToDeleteToken
        }
    }
    
    func storeTokenOnKeychain(token: Token) async throws {
        let accessToken = token.accessToken.data(using: .utf8)!
        let tag = "swiftyapp-token"
        let now = Date().timeIntervalSince1970
        let expirationDate = String(TimeInterval(now + token.expiresIn)).data(using: .utf8)!
        let addquery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                       kSecAttrAccount as String: tag,
                                       kSecAttrGeneric as String: expirationDate,
                                       kSecValueData as String: accessToken]
        
        let status = SecItemAdd(addquery as CFDictionary, nil)
        
        guard status != errSecDuplicateItem else {
            await updateLoginState(newState: true)
            throw AuthError.tokenAlreadyStored
        }
        
        guard status == errSecSuccess else {
            throw AuthError.failToStoreToken
        }
        
        await updateLoginState(newState: true)
    }
    
    
    @MainActor
    private func updateLoginState(newState: Bool) async {
        if isLoggedIn != newState {
            isLoggedIn = newState
        }
    }
    
}

