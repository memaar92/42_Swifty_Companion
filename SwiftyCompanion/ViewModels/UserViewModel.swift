//
//  IDViewModel.swift
//  SwiftyCompanion
//
//  Created by Marius Messerschmied on 26.11.24.
//

import SwiftUI

@Observable @MainActor
class UserViewModel {
    
    let networkManager = NetworkManager()
    var currentUser: FortyTwoUser?
    
    func getMyUser() async throws {
        let url = URL(string: "https://api.intra.42.fr/v2/me")!
        let (user, _) = try await networkManager.makeAuthorizedGetRequest(url: url) as (FortyTwoUser, _)
        
        self.currentUser = user
    }
    
    func getSelectedUser(id: Int) async throws {
        let url = URL(string: "https://api.intra.42.fr/v2/users/\(id)")!
        let (user, _) = try await networkManager.makeAuthorizedGetRequest(url: url) as (FortyTwoUser, _)
        
        self.currentUser = user
    }
    
}
