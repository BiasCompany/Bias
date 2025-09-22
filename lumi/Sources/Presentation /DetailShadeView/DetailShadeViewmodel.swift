import SwiftUI
import SwiftData

final class DetailShadeViewModel: ObservableObject {
    @Published var showUnfavoriteAlert: Bool = false
    @Published var isFavorite: Bool = false
    @Published var showUnfavoriteDialog : Bool = false
    let recommendation: ShadeRecommendation
    
    
    
    var percentage: Int { recommendation.percentage }
    var skinToneColor: Color {
        Color(hex: recommendation.skinTone.hex)
    }
    var shadeColor: Color {
        Color(hex: recommendation.shade.hexShade)
    }
    init(recommendation: ShadeRecommendation) {
        self.recommendation = recommendation
    }
    
    func toggleFavorite() {
        if isFavorite {
            showUnfavoriteAlert = true
        } else {
            isFavorite.toggle()
        }
    }

    func confirmRemoveFavorite() {
        isFavorite = false
        showUnfavoriteAlert = false
    }
}

