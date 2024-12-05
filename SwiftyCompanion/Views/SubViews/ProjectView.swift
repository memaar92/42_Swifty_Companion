//
//  ProjectView.swift
//  CardExperiment
//
//  Created by Marius Messerschmied on 23.11.24.
//

import SwiftUI

struct ProjectView: View {
    
    var projects: [Project]
    
    var body: some View {
        List(projects) { project in
            ProjectItemView(project: project)
                .padding(.bottom, -16)
                .padding(.top, 8)
        }
        .scrollContentBackground(.hidden)
        .scrollIndicators(.hidden)
        .listStyle(.plain)
        .padding(.leading, 16)
        .padding(.trailing, 16)
        .listRowSpacing(4)
    }
}


struct ProjectItemView: View {
    
    var project: Project
    
    var body: some View {
        HStack {
            HStack {
                Text(project.project.name)
                    .padding(.leading, 12)
                Spacer()
            }
            .frame(width: 275, height: 40)
            .background(Color.customWhite)
            Spacer()
            HStack {
                if project.validated == nil {
                    Text("🏃‍♂️")
                } else {
                    if project.validated == true {
                        Text("💪")
                    } else {
                        Text("💀")
                    }
                }
            }
            .frame(width: 60, height: 40)
            .background(Color.customWhite)
        }
        //.listRowBackground(Color.BG)
        .listRowBackground(
            Rectangle()
                .fill(Color.BG)
                .padding(
                    EdgeInsets(
                        top: 20,
                        leading: 0,
                        bottom: 20,
                        trailing: 0
                    )
                )
        )
        .listRowSeparator(.hidden)
    }
}

#Preview {
    ProjectView(projects: [])
}
