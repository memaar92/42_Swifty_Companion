//
//  UserModel.swift
//  SwiftyCompanion
//
//  Created by Marius Messerschmied on 02.12.24.
//

import SwiftUI

struct Peer: Decodable, Identifiable {
    let id: Int
    let login: String
    let kind: String
    let active: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case login = "login"
        case kind = "kind"
        case active = "active?"
    }
}

struct FortyTwoUser: Decodable, Identifiable {
    let id: Int
    let image: ImageLink
    let login: String
    let wallet: Int
    let correctionPoint: Int
    let cursusUsers: [Cursus]
    let projectsUsers: [Project]
}

struct ImageLink: Decodable {
    let link: String
}

struct Cursus: Decodable {
    let level: Double
    let skills: [Skill]
}

struct Skill: Decodable, Identifiable {
    let id: Int
    let name: String
    let level: Double
}

struct Project: Decodable, Identifiable {
    let id: Int
    let finalMark: Int?
    let validated: Bool?
    let status: String
    let project: ProjectName
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case finalMark = "finalMark"
        case validated = "validated?"
        case status = "status"
        case project = "project"
    }
}

struct ProjectName: Decodable {
    let name: String
}

