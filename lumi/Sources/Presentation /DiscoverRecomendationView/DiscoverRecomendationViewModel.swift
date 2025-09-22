//
//  DiscoverRecomendationViewModel.swift
//  lumi
//
//  Created by Muhammad Rifqi Syatria on 9/22/25.
//

import SwiftUI

final class DiscoverRecomendationViewModel: ObservableObject {
    @Published var searchText: String = ""
    let discoverRecomendation: [ShadeRecommendation]
    var skinToneColor: Color {
        guard let first = discoverRecomendation.first else { return .clear }
        return Color(hex: first.skinTone.hex)
    }
    var shadeColor: Color {
        guard let first = discoverRecomendation.first else { return .clear }
        return Color(hex: first.shade.hexShade)
    }

    init(shadeRecomendations: [ShadeRecommendation]) {
        self.discoverRecomendation = shadeRecomendations
        self.searchText = ""

    }
}
