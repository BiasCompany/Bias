//
//  AllShadeRecommendationView.swift
//  bias
//
//  Created by Muhammad Rifqi Syatria on 9/17/25.
//

import Foundation
import Combine

final class ChooseBrandViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published private(set) var allBrandNames: [String] = []
    @Published var selected: Set<String> = []

    init(repo: ProductRepositoryProtocol) {
        self.repo = repo
        load()
    }

    func load() {
        do { try repo.loadIfNeeded() } catch {
            print("ProductRepository load error:", error.localizedDescription)
        }

        let names = repo.allBrands().map { $0.name }
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        let uniqueSorted = Array(Set(names)).sorted {
            $0.localizedCaseInsensitiveCompare($1) == .orderedAscending
        }
        self.allBrandNames = uniqueSorted
    }

    // MARK: - Filtering
    var filteredBrands: [String] {
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !q.isEmpty else { return allBrandNames }
        return allBrandNames.filter { $0.localizedCaseInsensitiveContains(q) }
    }

    // MARK: - Sections (A-Z)
    var sections: [(key: String, values: [String])] {
        let grouped = Dictionary(grouping: filteredBrands) { brand -> String in
            guard let c = brand.first else { return "#" }
            let u = String(c).uppercased()
            return ("A"..."Z").contains(u) ? u : "#"
        }
        return grouped
            .map { (key: $0.key, values: $0.value.sorted { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending }) }
            .sorted { $0.key < $1.key }
    }

    var sectionTitles: [String] {
        sections.map { $0.key }
    }

    // MARK: - Selection
    func toggleSelection(_ name: String) {
        if selected.contains(name) { selected.remove(name) } else { selected.insert(name) }
    }

    var isAllSelectedInCurrentView: Bool {
        let visible = Set(filteredBrands)
        return !visible.isEmpty && visible.isSubset(of: selected)
    }

    func toggleSelectAll() {
        let visible = Set(filteredBrands)
        if visible.isSubset(of: selected) {
            selected.subtract(visible)
        } else {
            selected.formUnion(visible)
        }
    }

    var canContinue: Bool { !selected.isEmpty }
}


