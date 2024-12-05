//
//  FindPeersViewModel.swift
//  SwiftyCompanion
//
//  Created by Marius Messerschmied on 29.11.24.
//

import SwiftUI

@MainActor
class FindPeersViewModel: ObservableObject {
    
    let networkManager = NetworkManager()
    
    @Published var searchMode = false
    @Published var searchTerm: String = ""
    @Published var activeFilter = false
    var test: String = ""
    
    @Published var peers: [Peer] = []
    private var currentPage = 1
    private var canLoadMorePages = true
    
    @Published var peersSearch: [Peer] = []
    var searchTermSubmitted: String = ""
    private var currentPageSearch = 1
    private var canLoadMorePagesSearch = true
    
    @MainActor
    var filteredPeers: [Peer] {
        if searchTermSubmitted != searchTerm && !peersSearch.isEmpty {
            Task {
                self.resetSearch()
            }
            return []
        }
        
        guard !searchTerm.isEmpty else {
            if activeFilter {
                return peers.filter { $0.active == true }
            }
            return peers
        }
        
        if activeFilter {
            return peersSearch.filter { $0.active == true }
        }
        return peersSearch
    }
    
    // if moved to View then this only gets loaded when accessing the tab, else it already gets loaded when ParentTabView is accessed
    init() {
        Task {
            try await loadMoreContent()
        }
    }
    
    func loadMoreContentIfNeeded(currentPeer: Peer?) async throws {
        guard let currentPeer = currentPeer else {
            try await loadMoreContent()
            return
        }
        var arrayOnDisplay = searchMode ? peersSearch : peers
        if activeFilter {
            arrayOnDisplay = arrayOnDisplay.filter { $0.active == true }
        }
        var thresholdIndex = arrayOnDisplay.index(arrayOnDisplay.endIndex, offsetBy: -5)
        if thresholdIndex < 5 { thresholdIndex = arrayOnDisplay.index(arrayOnDisplay.endIndex, offsetBy: -1) }
        if arrayOnDisplay.firstIndex(where: { $0.id == currentPeer.id }) == thresholdIndex {
            try await loadMoreContent()
        }
    }
    

    func loadMoreContent() async throws {
        searchMode ? try await searchPeers() : try await getPeers()
    }
    
    func getPeers() async throws {
        guard canLoadMorePages else { return }
        
        let url = URL(string: "https://api.intra.42.fr/v2/campus/44/users?sort=login&page=\(currentPage)")!
        let (peers, response) = try await networkManager.makeAuthorizedGetRequest(url: url) as ([Peer], HTTPURLResponse)
                
        if let totalPages = Int(response.value(forHTTPHeaderField: "X-Total") ?? "0"), currentPage >= totalPages {
            canLoadMorePages = false
        }

        currentPage += 1
        
        self.peers += peers
    }
    
    func searchPeers() async throws {
        guard canLoadMorePagesSearch else { return }
        
        guard let url = URL(string: "https://api.intra.42.fr/v2/campus/44/users?range[login]=\(searchTermSubmitted.lowercased()),\(searchTermSubmitted.lowercased())z&sort=login&page=\(currentPageSearch)") else {
            throw SearchError.invalidSearchTerm
        }
        
        let (peersSearch, response) = try await networkManager.makeAuthorizedGetRequest(url: url) as ([Peer], HTTPURLResponse)
        
        if let totalPages = Int(response.value(forHTTPHeaderField: "X-Total") ?? "0"), currentPageSearch >= totalPages {
            canLoadMorePagesSearch = false
        }
        
        self.currentPageSearch += 1
        self.peersSearch += peersSearch

    }
    
    func resetSearch() {
        searchMode = false
        currentPageSearch = 1
        canLoadMorePagesSearch = true
        peersSearch.removeAll()
    }
    
}
