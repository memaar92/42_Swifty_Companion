//
//  Home.swift
//  CardExperiment
//
//  Created by Marius Messerschmied on 21.11.24.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        VStack{
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color .BG
                .ignoresSafeArea()
        }
    }
}

#Preview {
    BackgroundView()
}
