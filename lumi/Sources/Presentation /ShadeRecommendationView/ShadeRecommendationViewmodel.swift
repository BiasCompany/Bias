import SwiftUI
import SwiftData

@MainActor
final class ShadeRecommendationViewModel: ObservableObject {
    @Published var productService: ProductService
    
//    @Published var showUnfavoriteAlert: Bool = false
//    @Published var isFavorite: Bool = false
//    @Published var showUnfavoriteDialog : Bool = false
//    
    @Published var shadesRecommendation: [ShadeRecommendation] = []
    @Published var shadesRecommendationBrandPreference: [ShadeRecommendation] = []
    @Published var isLoading: Bool = true
    
    
    init() {
        productService = DIContainer.shared.productService
    }

    /// Load both: all recommendations and brand-preference recommendations.
    /// Also ensures matches are (re)calculated before fetching.
    func load() {
        Task { [weak self] in
            guard let self else { return }
            do {
                self.isLoading = true
                // Recalculate matches based on current skin tone / undertone and catalog
                try await self.productService.calculateMatches()

                // Fetch all recommendations
                let all = try await self.productService.getAllShadesRecommendation()
                // Fetch recommendations filtered by brand preference
                let byBrand = try await self.productService.getShadeRecommendationFromPreferences()

                self.shadesRecommendation = all
                self.shadesRecommendationBrandPreference = byBrand
            } catch {
                print("Error loading recommendations:", error)
                // In case of error, clear lists to avoid stale UI
                self.shadesRecommendation = []
                self.shadesRecommendationBrandPreference = []
            }
            self.isLoading = false
        }
    }
//
//    
//    func toggleFavorite() {
//        if isFavorite {
//            showUnfavoriteAlert = true
//        } else {
//            isFavorite.toggle()
//        }
//    }
//
//    func confirmRemoveFavorite() {
//        isFavorite = false
//        showUnfavoriteAlert = false
//    }
}
