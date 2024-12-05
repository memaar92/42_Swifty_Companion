//
//  ContentView.swift
//  SwiftyCompanion
//
//  Created by Marius Messerschmied on 23.11.24.
//

import SwiftUI

struct IDView: View {
    
    let user: FortyTwoUser?
    @State var isShowingDetailView = false
    
    var body: some View {
        ZStack {
            BackgroundView()
            Circle()
                .fill(Color .HL_1)
                .position(x: 50, y: 250)
                .frame(width: 300, height: 300)
            VStack {
                ProfileCardView(user: user)
                    .opacity(0.9)
                    .onTapGesture {
                        isShowingDetailView.toggle()
                    }
                Text("😎 \(user?.login ?? "")")
                    .padding(8)
                    .font(.custom("ChivoMono-Light", size: 30))
                    .background(Color.customWhite)
                VStack (alignment: .leading) {
                    DetailItemView(detail: "level",
                                   value: Text("\(user?.cursusUsers[safe: 1]?.level ?? 0, specifier: "%.2f")"))
                    DetailItemView(detail: "wallet",
                                    value: Text("\(user?.wallet ?? 0)₳"))
                    DetailItemView(detail: "eval points",
                                    value: Text("\(user?.correctionPoint ?? 0)"))
                }
                .frame(maxWidth: 235)
                Spacer()
            }
            .sheet(isPresented: $isShowingDetailView) {
                DetailView(user: user)
                    .presentationDragIndicator(.visible)
            }
        }
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        return index >= 0 && index < count ? self[index] : nil
    }
}


struct DetailItemView: View {
    
    let detail: String
    let value: Text
    
    var body: some View {
        HStack {
            Text(detail)
                .multilineTextAlignment(.leading)
            Spacer()
            value
                .font(.body)
                .multilineTextAlignment(.trailing)
        }
        .padding(4)
    }
}


struct ProfileCardView: View {
    
    var user: FortyTwoUser?
    
    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: user?.image.link ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
            }
        }
        .frame(width: 325, height: 418)
        .cornerRadius(16)
        .padding(32)
        .shadow(radius: 8)
    }
}


#Preview {
    let test = Cursus(level: 0, skills: [])
    let mockUser = FortyTwoUser(id: 0, image: ImageLink(link: ""), login: "", wallet: 0, correctionPoint: 0, cursusUsers: [test, test], projectsUsers: [])
    IDView(user: mockUser)
}
