//
//  MeView.swift
//  SwiftyCompanion
//
//  Created by Marius Messerschmied on 01.12.24.
//

import SwiftUI

struct MeView: View {
    
    @Environment(UserViewModel.self) var viewModel
    
    var body: some View {
        ZStack {
            BackgroundView()
            ScrollView {
                IDView(user: viewModel.currentUser)
            }
        }
    }
}

#Preview {
    MeView()
        .environment(UserViewModel())
}
