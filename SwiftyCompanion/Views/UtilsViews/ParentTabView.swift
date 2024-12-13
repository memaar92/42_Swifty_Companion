//
//  ParentTabView.swift
//  SwiftyCompanion
//
//  Created by Marius Messerschmied on 30.11.24.
//

import SwiftUI

struct ParentTabView: View {
    
    @State var userViewModel = UserViewModel()
    @State private var showingAlert = false
    @State private var selectedAlert: AlertItem?
    
    var body: some View {
        TabView {
            MeView()
                .tabItem {
                    Label("Me", systemImage: "widget.small")
                }
            FindPeersView()
                .tabItem {
                    Label("Find Peers", systemImage: "magnifyingglass")
                }
            LogoutView()
                .tabItem {
                    Label("Adventure", systemImage: "mountain.2")
                        .environment(\.symbolVariants, .none)
                }
        }
        .accentColor(.PB)
        .environment(userViewModel)
        .task {
            await fetchUserData()
        }
        .alert(selectedAlert?.title ?? Text("Server Error"), isPresented: $showingAlert, presenting: selectedAlert, actions: {detail in
            if detail == AlertContext.noUserData {
                Button("Retry") {
                    Task {
                        await fetchUserData() }
                }
            } else {
                Button("OK") {
                    Task { try await AuthManager.shared.deleteTokenOnKeychain() }
                }
            }
            
        }, message: { detail in detail.message })
    }
    
    
    private func fetchUserData() async {
        do {
            try await userViewModel.getMyUser()
        } catch NetworkError.noResponse, NetworkError.responseNotDecodable, NetworkError.unsuccessfulResponse {
            selectedAlert = AlertContext.noUserData
            showingAlert = true
        } catch {
            selectedAlert = AlertContext.expiredAuth
            showingAlert = true
        }
    }
}


#Preview {
    ParentTabView()
}
