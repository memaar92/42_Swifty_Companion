//
//  CustomSegmentedView.swift
//  CardExperiment
//
//  Created by Marius Messerschmied on 23.11.24.
//

import SwiftUI

struct CustomSegmentedView: View {
    
    let segments: [String]
    @Binding var selected: String
    @Namespace var name
    
    var body: some View {
        HStack {
            ForEach(segments, id: \.self) { segment in
                Button {
                    // may add withAnimation
                    selected = segment
                } label: {
                    VStack {
                        Text(segment)
                            .font(.subheadline)
                            .fontWeight(selected == segment ? .bold : .medium)
                            .foregroundColor(selected == segment ? .primary : .secondary)
                        ZStack {
                            Rectangle()
                                .fill(Color.clear)
                                .frame(height: 4)
                            if selected == segment {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 98, height: 2)
                                    .background(Color(red: 0.22, green: 0.21, blue: 0.21))
                                    .matchedGeometryEffect(id: "Tab", in: name)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    CustomSegmentedView(segments: .init(["One", "Two", "Three"]), selected: .constant("One"))
}
