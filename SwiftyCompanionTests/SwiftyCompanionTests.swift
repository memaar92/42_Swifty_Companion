//
//  SwiftyCompanionTests.swift
//  SwiftyCompanionTests
//
//  Created by Marius Messerschmied on 23.11.24.
//

import Testing
import SwiftUI
@testable import SwiftyCompanion

struct SwiftyCompanionTests {

    @Test("Check if more peers can be loaded", arguments: [
        ("1", 1, false),
        ("2", 1, false), // this is should be false because getPeers() gets additionally called once FindPeersViewModel is initialized
        ("2", 2, false),
        ("3", 1, true),
        ("10", 5, true)
    ])  func canLoadMorePagesTest(xTotal: String, numCalls: Int, result: Bool) async throws {
        var mockNetworkManager = MockNetworkManager()
        let mockPeers: [Peer] = [Peer(id: 1, login: "username", kind: "student", active: true)]
        mockNetworkManager.mockResponse = (mockPeers, HTTPURLResponse(url: URL(string: "https://test.test")!,
                                                                      statusCode: 200,
                                                                      httpVersion: nil,
                                                                      headerFields: ["X-Total": xTotal])!)
        
        let viewModel = await FindPeersViewModel(networkManager: mockNetworkManager)
        for _ in 1...numCalls {
            try await viewModel.getPeers()
        }
        await #expect(viewModel.canLoadMorePages == result)
    }

}

