//
//  ErrorModel.swift
//  SwiftyCompanion
//
//  Created by Marius Messerschmied on 28.11.24.
//

import SwiftUI

enum NetworkError: Error {
    case noResponse
    case unsuccessfulResponse
    case responseNotDecodable
}

enum AuthError: Error {
    case missingAuthCode
    case invalidRefreshToken
    case invalidAccessToken
    case missingAccessToken
    case failToDeleteToken
    case tokenAlreadyStored
    case failToStoreToken
}

enum SearchError: Error {
    case invalidSearchTerm
}
