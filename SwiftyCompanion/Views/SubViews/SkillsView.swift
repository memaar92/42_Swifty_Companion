//
//  SkillsView.swift
//  CardExperiment
//
//  Created by Marius Messerschmied on 23.11.24.
//

import SwiftUI

struct SkillsView: View {
    
    var skills: [Skill]
    
    var body: some View {
        List(skills) { skill in
            SkillItemView(skill: skill)
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


struct SkillItemView: View {
    
    var skill: Skill
    
    var body: some View {
        HStack {
            HStack {
                Text(skill.name)
                    .padding(.leading, 12)
                Spacer()
            }
            .frame(width: 275, height: 40)
            .background(Color.customWhite)
            Spacer()
            HStack {
                Text("\(skill.level, specifier: "%.2f")")
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
    let skill = Skill(id: 1, name: "SwiftUI", level: 0.8)
    let skill2 = Skill(id: 1, name: "SwiftUI", level: 0.8)
    SkillsView(skills: [skill, skill2])
}
