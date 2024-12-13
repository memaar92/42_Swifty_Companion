//
//  LogoutView.swift
//  SwiftyCompanion
//
//  Created by Marius Messerschmied on 29.11.24.
//

import SwiftUI

struct LogoutView: View {
    
    @Environment(UserViewModel.self) var viewModel
    
    var userName: AttributedString {
        var result = " " + AttributedString(viewModel.currentUser?.login ?? "Frodo") + " "
        result.backgroundColor = .customWhite
        return result
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                Spacer()
                Circle()
                    .foregroundStyle(Color.HL_2)
                    .frame(width: 50, height: 50)
                    .padding()
                Text("It's a dangerous business,\n" + userName + ", going out your door.\nYou step onto the road, and if you don't keep your feet, there's no knowing where you might be swept off to. This Swifty Companion may help you, so think twice before logging out.")
                    .multilineTextAlignment(.center)
                    .lineSpacing(10)
                    .frame(width: 260)
                Text("Hitchhiker's Guide \n (Tolkien Series)")
                    .multilineTextAlignment(.center)
                    .font(.custom("ChivoMono-Light", size: 16))
                    .padding()
                Rectangle()
                    .frame(width: 50, height: 5)
                Button {
                    Task {
                        try await AuthManager.shared.deleteTokenOnKeychain()
                    }
                } label: {
                    Text("Logout")
                        .foregroundStyle(.red)
                }
                .padding()
                Spacer()
            }
        }
    }
}

#Preview {
    LogoutView()
        .environment(UserViewModel())
}
