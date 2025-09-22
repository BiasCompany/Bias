

import SwiftUI
import SwiftData

final class ShadeRecommendationViewModel: ObservableObject {
    @Published var showUnfavoriteAlert: Bool = false
    @Published var isFavorite: Bool = false
    @Published var showUnfavoriteDialog : Bool = false
    let recommendation: ShadeRecommendation
    
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
