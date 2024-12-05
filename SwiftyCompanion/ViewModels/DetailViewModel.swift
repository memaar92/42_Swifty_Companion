//
//  DetailViewModel.swift
//  CardExperiment
//
//  Created by Marius Messerschmied on 23.11.24.
//

import SwiftUI

final class DetailViewModel: ObservableObject {
    @Published var segmentTitles: [String] = ["Projects", "Skills"]
    
}
