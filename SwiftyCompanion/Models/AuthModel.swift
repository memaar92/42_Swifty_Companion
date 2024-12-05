//
//  AuthModel.swift
//  SwiftyCompanion
//
//  Created by Marius Messerschmied on 02.12.24.
//

import SwiftUI

struct Token: Decodable {
    let accessToken: String
    let tokenType: String // may remove
    let expiresIn: Double
    let scope: String // may remove
    let createdAt: Double
}

struct AuthCodeData: Encodable {
    let code: String
    let client_id: String
    let client_secret: String
    let grant_type: String
    let redirect_uri: String
}

