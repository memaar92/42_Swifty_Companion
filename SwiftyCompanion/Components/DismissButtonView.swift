//
//  DismissButtonView.swift
//  CardExperiment
//
//  Created by Marius Messerschmied on 23.11.24.
//

import SwiftUI

struct DismissButtonView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        HStack {
            Spacer()
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(Color(.label))
                    .imageScale(.medium)
                    .frame(width: 32, height: 32)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(Circle())
                    .frame(width: 44, height: 44)
            }
        }

        .padding()
    }
}

#Preview {
    DismissButtonView()
}
