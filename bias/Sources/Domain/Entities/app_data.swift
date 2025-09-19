import SwiftData
import Foundation
import SwiftUI

@Model
class AppData {
    var isFirstTime: Bool
    var brands: [Brand]
    var shades: [Shade]
    var userPreferenceBrands: [String]
    var userUndertone: Undertone
    var userSkinTone: SkinTone?
    var shadeRecommendationList: [ShadeRecommendation]
    var favoriteShadeList: [ShadeRecommendation]
    var noteShadeList: [ShadeRecommendation]

    init(
        isFirstTime: Bool = true,
        brands: [Brand] = [],
        shades: [Shade] = [],
        userPreferenceBrands: [String] = [],
        userUndertone: Undertone = .neutral,
        userSkinTone: SkinTone? = nil,
        shadeRecommendationList: [ShadeRecommendation] = [],
        favoriteShadeList: [ShadeRecommendation] = [],
        noteShadeList: [ShadeRecommendation] = []
    ) {
        self.isFirstTime = isFirstTime
        self.brands = brands
        self.shades = shades
        self.userPreferenceBrands = userPreferenceBrands
        self.userUndertone = userUndertone
        self.userSkinTone = userSkinTone
        self.shadeRecommendationList = shadeRecommendationList
        self.favoriteShadeList = favoriteShadeList
        self.noteShadeList = noteShadeList
    }
}
