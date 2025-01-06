//
//  FindPeersView.swift
//  SwiftyCompanion
//
//  Created by Marius Messerschmied on 29.11.24.
//

import SwiftUI

struct FindPeersView: View {
    
    @State private var viewModel = FindPeersViewModel(networkManager: NetworkManager())
    @State private var navPath = NavigationPath()
    @State private var showingAlert = false
    @State private var selectedAlert: AlertItem?
    
    var body: some View {
        NavigationStack (path: $navPath) {
            ZStack {
                BackgroundView()
                VStack {
                    HStack {
                        activeFilterButtonView(activeFilter: $viewModel.activeFilter)
                        Spacer()
                    }
                    .padding(.leading)
                    List {
                        ForEach(viewModel.filteredPeers) { peer in
                            NavigationLink(value: peer.id) {
                                peerItemView(peer: peer)
                                    .onAppear {
                                        Task {
                                            await loadMoreItems(currentPeer: peer)
                                        }
                                    }
                            }
                            .listRowBackground(
                                Rectangle()
                                    .fill(Color.customWhite)
                                    .padding(
                                        EdgeInsets(
                                            top: 4,
                                            leading: 0,
                                            bottom: 4,
                                            trailing: 0
                                        )
                                    )
                            )
                            .listRowSeparator(.hidden)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .navigationDestination(for: Int.self) { peerID in
                        PeerIDView(navPath: $navPath, userID: peerID)
                    }
                    .searchable(text: $viewModel.searchTerm, prompt: "Find peers")
                    .autocapitalization(.none)
                    .onSubmit(of: .search) {
                        viewModel.searchMode = true
                        viewModel.searchTermSubmitted = viewModel.searchTerm
                        Task {
                            await loadSearchContent()
                        }
                    }
                }
            }
            
        }
        .alert(selectedAlert?.title ?? Text("Server Error"), isPresented: $showingAlert, presenting: selectedAlert, actions: {detail in
            if detail == AlertContext.invalidSeachTerm || detail == AlertContext.noAdditionalPeersData {
                Button("OK") {}
            }
            else if detail == AlertContext.noPeersData {
                Button("Retry") {
                    Task { await loadSearchContent() }
                }
                Button("Cancel", role: .cancel, action: {})
            } else {
                Button("OK") {
                    Task { try await AuthManager.shared.deleteTokenOnKeychain() }
                }
            }
        }, message: { detail in detail.message })
    }
    
    
    private func loadSearchContent() async {
        do {
            try await viewModel.loadMoreContent()
        } catch SearchError.invalidSearchTerm {
            selectedAlert = AlertContext.invalidSeachTerm
            showingAlert = true
        } catch NetworkError.noResponse, NetworkError.responseNotDecodable, NetworkError.unsuccessfulResponse {
            selectedAlert = AlertContext.noPeersData
            showingAlert = true
        } catch {
            selectedAlert = AlertContext.expiredAuth
            showingAlert = true
        }
    }
    
    private func loadMoreItems(currentPeer: Peer) async {
        do {
            try await viewModel.loadMoreContentIfNeeded(currentPeer: currentPeer)
        } catch NetworkError.noResponse, NetworkError.responseNotDecodable, NetworkError.unsuccessfulResponse {
            selectedAlert = AlertContext.noAdditionalPeersData
            showingAlert = true
        } catch {
            selectedAlert = AlertContext.expiredAuth
            showingAlert = true
        }
    }
    
}


struct activeFilterButtonView: View {
    @Binding var activeFilter: Bool
    
    var body: some View {
        Button {
            activeFilter.toggle()
        } label: {
            HStack {
                Image(systemName: activeFilter ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease")
                    .frame(height: 16)
                Text("active")
                    .font(.footnote)
            }
            .padding(8)
            .background(activeFilter ? Color.HL_1 : Color.customWhite)
            .foregroundColor(activeFilter ? Color.white: Color.black)
            .cornerRadius(8)
        }
    }
}

struct peerItemView: View {
    
    var peer: Peer
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack (spacing: 4) {
                Text(peer.login)
                    .font(.headline)
                Circle()
                    .fill(peer.active ? Color.HL_1 : Color.HL_2)
                    .frame(width: 6, height: 6)
            }
            Text(peer.kind)
        }
        .padding(4)
    }
}


#Preview {
    FindPeersView()
}
