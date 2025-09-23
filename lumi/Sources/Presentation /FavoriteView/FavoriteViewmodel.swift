//
//  FavoriteViewmodel.swift
//  lumi
//
//  Created by Shafa Tiara Tsabita Himawan on 21/09/25.
//

import SwiftData
import SwiftUI

@MainActor
final class FavoriteViewModel: ObservableObject {
    var service: FavoriteService
    @Published var isLoading: Bool = true
    @Published var favorites: [ShadeRecommendation] = []

    init() {
        service = DIContainer.shared.favoriteService
        load()
//        // Dummy data sementara (ganti nanti dengan fetch dari SwiftData)
//        favorite = [
//            ShadeRecommendation(
//                id: UUID(),
//                shade: Shade.dummy,
//                skinTone: .medium,
//                undertone: .cool,
//                percentage: 96
//            ),
//            ShadeRecommendation(
//                id: UUID(),
//                shade: .dummy,
//                skinTone: .medium,
//                undertone: .neutral,
//                percentage: 91
//            ),
//        ]
    }
    
    
    func load() {
        Task {
            do {
                isLoading = true
                favorites = try await service.getFavorites()
            } catch {
                print("Error loading brands:", error)
            }
            isLoading = false
        }
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
            hexShade: "#D2B48C",
            note: ""
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
