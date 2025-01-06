//
//  HomeView.swift
//  SwiftyCompanion
//
//  Created by Marius Messerschmied on 23.11.24.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var authManager = AuthManager.shared
    @State private var isLoading = true
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            } else if !authManager.isLoggedIn {
                LoginView()
            } else {
                ParentTabView()
            }
        }
        .onAppear {
            Task {
                isLoading = true
                // if checkToken throws; in all cases isLoggedIn is getting set to false
                defer { isLoading = false }
                try await authManager.checkToken()
            }
        }        
    }
}

#Preview {
    HomeView()
}
