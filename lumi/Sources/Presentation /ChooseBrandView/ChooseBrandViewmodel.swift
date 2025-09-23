//
//  AllShadeRecommendationView.swift
//  lumi
//
//  Created by Muhammad Rifqi Syatria on 9/17/25.
//

import Combine
import Foundation

@MainActor
final class ChooseBrandViewModel: ObservableObject {
    @Published var productService: ProductService
    @Published var searchText: String = ""
    @Published var isLoading: Bool = true
    @Published var brands: [Brand] = []
    @Published var selectedBrands: Set<Brand> = []

    init() {
        productService = DIContainer.shared.productService
        load()
    }

    func load() {
        Task {
            do {
                isLoading = true
                brands = try await productService.getBrands()
                let selectedBrands = try await productService.getBrandPreference()
                self.selectedBrands = Set(selectedBrands)
            } catch {
                print("Error loading brands:", error)
            }
            isLoading = false
        }
    }

    // MARK: - Filtering
    var filteredBrands: [Brand] {
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return brands }
        return brands.filter { $0.localizedCaseInsensitiveContains(q) }
    }

    // MARK: - Sections (A-Z)
    var sections: [(key: String, values: [Brand])] {
        let grouped = Dictionary(grouping: filteredBrands) { brand -> String in
            guard let c = brand.first else { return "#" }
            let u = String(c).uppercased()
            return ("A"..."Z").contains(u) ? u : "#"
        }
        return
            grouped
            .map {
                (
                    key: $0.key,
                    values: $0.value.sorted {
                        $0.localizedCaseInsensitiveCompare($1) == .orderedAscending
                    }
                )
            }
            .sorted { $0.key < $1.key }
    }

    var sectionTitles: [String] {
        sections.map { $0.key }
    }

    // MARK: - Selection
    func toggleSelection(_ name: Brand) {
        if selectedBrands.contains(name) {
            selectedBrands.remove(name)
        } else {
            selectedBrands.insert(name)
        }
    }

    var isAllSelectedInCurrentView: Bool {
        let visible = Set(filteredBrands)
        return !visible.isEmpty && visible.isSubset(of: selectedBrands)
    }

    func toggleSelectAll() {
        let visible = Set(filteredBrands)
        if visible.isSubset(of: selectedBrands) {
            selectedBrands.subtract(visible)
        } else {
            selectedBrands.formUnion(visible)
        }
    }

    func saveSelection() async throws {
        
            try await productService.saveBrandPreference(Array(selectedBrands))
        
    }

}
