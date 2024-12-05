//
//  AlertModel.swift
//  SwiftyCompanion
//
//  Created by Marius Messerschmied on 26.11.24.
//

import SwiftUI

struct AlertItem: Identifiable, Equatable {
    let id = UUID()
    let title: Text
    let message: Text
}

struct AlertContext {
    static let missingAuth = AlertItem(
        title: Text("Authentication Failed"),
        message: Text("We could not authenticate you. Please try again later.")
    )
    static let noResponse = AlertItem(
        title: Text("Server Error"),
        message: Text("Could not connect to 42. Please try again later.")
    )
    static let genericError = AlertItem(
        title: Text("Server Error"),
        message: Text("Something went wrong. Please try again later.")
    )
    static let noUserData = AlertItem(
        title: Text("We couldn't find you"),
        message: Text("Ensure you have internet access and try again. If the issue persists, please contact our support.")
    )
    static let noPeerData = AlertItem(
        title: Text("We couldn't find the peer you were looking for"),
        message: Text("Ensure you have internet access and try again.")
    )
    static let noPeersData = AlertItem(
        title: Text("We couldn't find your peers"),
        message: Text("Ensure you have internet access and try again. If the issue persists, please contact our support.")
    )
    static let noAdditionalPeersData = AlertItem(
        title: Text("We couldn't find any additional peers"),
        message: Text("We expected to find more of your peers. Ensure you have internet access and try again.")
    )
    static let invalidSeachTerm = AlertItem(
        title: Text("Invalid Search"),
        message: Text("Please enter a valid search term. For example try an intra name of a friend.")
    )
    static let expiredAuth = AlertItem(
        title: Text("Authentication Failed"),
        message: Text("We could not authenticate you. Please log in again.")
    )
    
}
