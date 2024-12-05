//
//  PeerIDView.swift
//  SwiftyCompanion
//
//  Created by Marius Messerschmied on 01.12.24.
//

import SwiftUI

struct PeerIDView: View {
    
    @StateObject private var viewModel = UserViewModel()
    @State private var showingAlert = false
    @State private var selectedAlert: AlertItem?
    @Binding var navPath: NavigationPath
    let userID: Int
    
    var body: some View {
        ZStack {
            BackgroundView()
            ScrollView {
                VStack {
                    IDView(user: viewModel.user)
                        .padding(.top, -20)
                }
                .onAppear {
                    Task { await fetchUserData() }
                }
                .alert(selectedAlert?.title ?? Text("Server Error"), isPresented: $showingAlert, presenting: selectedAlert, actions: {detail in
                    if detail == AlertContext.noPeerData {
                        Button("OK") {
                            navPath.removeLast()
                        }
                    } else {
                        Button("OK") {
                            Task { try await AuthManager.shared.deleteTokenOnKeychain() }
                        }
                    }
                }, message: { detail in detail.message })
            }
        }
    }
    
    private func fetchUserData() async {
        do {
            try await viewModel.getSelectedUser(id: userID)
        } catch NetworkError.noResponse, NetworkError.responseNotDecodable, NetworkError.unsuccessfulResponse {
            selectedAlert = AlertContext.noPeerData
            showingAlert = true
        } catch {
            selectedAlert = AlertContext.expiredAuth
            showingAlert = true
        }
    }
    
}

#Preview {
    @Previewable @State var pathMock = NavigationPath()
    PeerIDView(navPath: $pathMock, userID: 42)
}
