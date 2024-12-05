//
//  ButtonView.swift
//  SwiftyCompanion
//
//  Created by Marius Messerschmied on 23.11.24.
//

import SwiftUI

struct ButtonView: View {
    
    var title: String
    
    var body: some View {
        Text(title)
            .font(.title3)
            .fontWeight(.medium)
            .frame(width: 361, height: 48)
            .background(Color.PB)
            .foregroundColor(.customLightText)
            .cornerRadius(24)
    }
}

#Preview {
    ButtonView(title: "Test title")
}
