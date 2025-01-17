//
//  FindPeersViewModel.swift
//  SwiftyCompanion
//
//  Created by Marius Messerschmied on 29.11.24.
//

import SwiftUI

protocol NetworkManagerProtocol: Sendable {
    func makeAuthorizedGetRequest<T: Decodable>(url: URL) async throws -> (T, HTTPURLResponse)
}

@Observable @MainActor
final class FindPeersViewModel {
    
    let networkManager: any NetworkManagerProtocol
    
    var searchMode = false
    var searchTerm: String = ""
    var activeFilter = false
    var test: String = ""
    
    var peers: [Peer] = []
    private var currentPage = 1
    private(set) var canLoadMorePages = true
    
    var peersSearch: [Peer] = []
    var searchTermSubmitted: String = ""
    private var currentPageSearch = 1
    private var canLoadMorePagesSearch = true
    
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
    
    init(networkManager: any NetworkManagerProtocol) {
        // if moved to View then this only gets loaded when accessing the tab, else it already gets loaded when ParentTabView is accessed
        self.networkManager = networkManager
        Task { try await loadMoreContent() }
    }
    
    func loadMoreContentIfNeeded(currentPeer: Peer?) async throws {
        guard let currentPeer else {
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
