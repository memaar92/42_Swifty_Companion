//
//  IDViewModel.swift
//  SwiftyCompanion
//
//  Created by Marius Messerschmied on 26.11.24.
//

import SwiftUI

@MainActor
class UserViewModel: ObservableObject {
    
    let networkManager = NetworkManager()
    @Published var user: FortyTwoUser?
    
    func getMyUser() async throws {
        let url = URL(string: "https://api.intra.42.fr/v2/me")!
        let (user, _) = try await networkManager.makeAuthorizedGetRequest(url: url) as (FortyTwoUser, _)
        
        self.user = user
    }
    
    func getSelectedUser(id: Int) async throws {
        let url = URL(string: "https://api.intra.42.fr/v2/users/\(id)")!
        let (user, _) = try await networkManager.makeAuthorizedGetRequest(url: url) as (FortyTwoUser, _)
        
        self.user = user
    }
    
}
