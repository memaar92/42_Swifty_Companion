//
//  SwiftyCompanionApp.swift
//  SwiftyCompanion
//
//  Created by Marius Messerschmied on 23.11.24.
//

import SwiftUI

@main
struct SwiftyCompanionApp: App {
    var body: some Scene {
        WindowGroup {
            ZStack {
                Color .BG
                    .ignoresSafeArea()
                HomeView()
            }
        }
    }
}
