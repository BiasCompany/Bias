//
//  FavoriteViewmodel.swift
//  lumi
//
//  Created by Shafa Tiara Tsabita Himawan on 21/09/25.
//

import SwiftData
import SwiftUI

final class FavoriteViewModel: ObservableObject {
    @Published var favorite: [ShadeRecommendation] = []

    init() {
        // Dummy data sementara (ganti nanti dengan fetch dari SwiftData)
        favorite = [
            ShadeRecommendation(
                id: UUID(),
                shade: Shade.dummy,
                skinTone: .medium,
                undertone: .cool,
                notes: "",
                lastUpdatedNote: .now,
                percentage: 96
            ),
            ShadeRecommendation(
                id: UUID(),
                shade: .dummy,
                skinTone: .medium,
                undertone: .neutral,
                notes: "",
                lastUpdatedNote: .now,
                percentage: 91
            ),
        ]
    }
}

// MARK: - ShadeRecommendation Display Properties
extension ShadeRecommendation {
    var displayBrand: String {
        return shade.brand
    }

    var displayProductLine: String {
        return shade.product
    }

    var displayShadeCode: String {
        return shade.name
    }

    var displayMatch: Double {
        return Double(percentage) / 100.0
    }

    var displayShadeColor: Color {
        Color(hex: shade.hexShade)
    }

    var displaySkinToneColor: Color {
        Color(hex: skinTone.hex)
    }

    var displayImageURL: URL? {
        return URL(string: shade.image)
    }
}

// MARK: - Dummies for slicing only
extension Shade {
    static var dummy: Shade {
        .init(
            id: UUID(),
            name: "120C",
            brand: "WARDAH",
            product: "ALL HOURS FOUNDATION",
            description: "Medium skin tone",
            image: "https://images.ulta.com/is/image/Ulta/2300153sw?",
            undertone: .cool,
            hexShade: "#D2B48C"
        )
    }
}

extension SkinTone {
    static var medium: SkinTone {
        .init(
            id: UUID(),
            name: "Medium",
            hex: "#D2B48C",
            date: .now
        )
    }
}
