//
//  DetailView.swift
//  CardExperiment
//
//  Created by Marius Messerschmied on 21.11.24.
//

import SwiftUI

struct DetailView: View {
    
    @State private var viewModel = DetailViewModel()
    @State private var currentSegment = "Projects"
    let user: FortyTwoUser?
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                DismissButtonView()
                CustomSegmentedView(segments: viewModel.segmentTitles, selected: $currentSegment)
                    .padding(.bottom, 4)
                if (currentSegment == "Projects") {
                    ProjectView(projects: user?.projectsUsers ?? [])
                }
                else if (currentSegment == "Skills") {
                    SkillsView(skills: user?.cursusUsers[safe: 1]?.skills ?? [])
                }
            }
        }
    }
}


#Preview {
    let test = Cursus(level: 0, skills: [])
    let mockUser = FortyTwoUser(id: 0, image: ImageLink(link: ""), login: "", wallet: 0, correctionPoint: 0, cursusUsers: [test, test], projectsUsers: [])
    DetailView(user: mockUser)
}
