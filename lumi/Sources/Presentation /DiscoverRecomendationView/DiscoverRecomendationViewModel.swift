//
//  DiscoverRecomendationViewModel.swift
//  lumi
//
//  Created by Muhammad Rifqi Syatria on 9/22/25.
//

import SwiftUI

@MainActor
final class DiscoverRecomendationViewModel: ObservableObject {
    private var productService: ProductService
    var isLoading = true

    // Raw data loaded from the service
    private var allRecommendations: [ShadeRecommendation] = []

    // Search input
    @Published var searchText: String = "" {
        didSet {
            filterRecommendations()
        }
    }

    // Filtered data exposed to the UI
    @Published var discoverRecomendation: [ShadeRecommendation] = []

    init () {
        productService = DIContainer.shared.productService
    }
    
    func load() {
        Task {
            isLoading = true
            let fetched = try await productService.getAllShadesRecommendation()
            allRecommendations = fetched
            filterRecommendations()
            isLoading = false
        }
    }
    
    /// Filters recommendations by product based on `searchText`.
    /// If `searchText` is empty, shows all recommendations.
    func filterRecommendations() {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            discoverRecomendation = allRecommendations
            return
        }

        // Adjust the property names below to match `ShadeRecommendation` structure.
        // This assumes `ShadeRecommendation` has a `product` field with a `name`.
        discoverRecomendation = allRecommendations.filter { rec in
            // Try matching against product name and any other relevant fields
            let productName = (rec.shade.product)
            return productName.localizedCaseInsensitiveContains(query)
        }
    }
}
