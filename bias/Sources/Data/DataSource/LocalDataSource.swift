import Foundation
import SwiftData

@MainActor
final class LocalDataSource: ObservableObject {

    // MARK: Lifecycle

    let container: ModelContainer
    var context: ModelContext { container.mainContext }

    init(container: ModelContainer) {
        self.container = container
    }

    static func makeDefaultContainer(isStoredInMemory: Bool = false) throws -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: isStoredInMemory)
        return try ModelContainer(
            for: AppData.self,
                Shade.self,
                SkinTone.self,
                ShadeRecommendation.self,
            configurations: config
        )
    }

    // MARK: - AppData root

    func getOrCreateAppData() throws -> AppData {
        let fetch = FetchDescriptor<AppData>()
        if let existing = try context.fetch(fetch).first {
            return existing
        }
        let created = AppData()
        context.insert(created)
        try context.save()
        return created
    }

    func updateAppData(_ apply: (AppData) -> Void) throws {
        let root = try getOrCreateAppData()
        apply(root)
        try context.save()
    }

    // MARK: - Brands & Preferences

    func setBrandsCatalog(_ brands: [Brand]) throws {
        try updateAppData { $0.brands = brands }
    }

    func getBrandsCatalog() throws -> [Brand] {
        try getOrCreateAppData().brands
    }

    func setUserPreferenceBrands(_ brands: [String]) throws {
        try updateAppData { $0.userPreferenceBrands = brands }
    }

    func getUserPreferenceBrands() throws -> [String] {
        try getOrCreateAppData().userPreferenceBrands
    }

    // MARK: - Shades

    @discardableResult
    func insertAllShades(_ shades: [Shade]) throws -> [Shade] {
        let root = try getOrCreateAppData()
        for shade in shades {
            context.insert(shade)
            if !root.shades.contains(where: { $0.id == shade.id }) {
                root.shades.append(shade)
            }
        }
        try context.save()
        return root.shades
    }

    func fetchShades() throws -> [Shade] {
        let fd = FetchDescriptor<Shade>(sortBy: [
            SortDescriptor(\.brand, order: .forward),
            SortDescriptor(\.product, order: .forward),
            SortDescriptor(\.name, order: .forward)
        ])
        return try context.fetch(fd)
    }

    // MARK: - Recommendations

    @discardableResult
    func insertAllRecommendations(_ recs: [ShadeRecommendation]) throws -> [ShadeRecommendation] {
        let root = try getOrCreateAppData()
        for rec in recs {
            context.insert(rec)
            if !root.shadeRecommendationList.contains(where: { $0.id == rec.id }) {
                root.shadeRecommendationList.append(rec)
            }
        }
        try context.save()
        return root.shadeRecommendationList
    }

    func fetchRecommendations() throws -> [ShadeRecommendation] {
        try context.fetch(
            FetchDescriptor<ShadeRecommendation>(
                sortBy: [
                    SortDescriptor(\.percentage, order: .reverse),
                    SortDescriptor(\.lastUpdatedNote, order: .reverse)
                ]
            )
        )
    }

    func deleteAllRecommendations() throws {
        let all = try fetchRecommendations()
        all.forEach { context.delete($0) }
        let root = try getOrCreateAppData()
        root.shadeRecommendationList.removeAll()
        root.favoriteShadeList.removeAll()
        root.noteShadeList.removeAll()
        try context.save()
    }

    // MARK: - Favorites

    func saveFavorite(_ rec: ShadeRecommendation) throws {
        let root = try getOrCreateAppData()
        if !root.favoriteShadeList.contains(rec) {
            root.favoriteShadeList.append(rec)
        }
        try context.save()
    }

    func getFavorites() throws -> [ShadeRecommendation] {
        try getOrCreateAppData().favoriteShadeList
    }

    func deleteFavorite(_ rec: ShadeRecommendation) throws {
        let root = try getOrCreateAppData()
        root.favoriteShadeList.removeAll { $0 == rec }
        try context.save()
    }

    // MARK: - Notes

    func saveNote(_ rec: ShadeRecommendation) throws {
        let root = try getOrCreateAppData()
        if !root.noteShadeList.contains(rec) {
            root.noteShadeList.append(rec)
        }
        rec.lastUpdatedNote = .now
        try context.save()
    }

    func getNotes() throws -> [ShadeRecommendation] {
        try getOrCreateAppData().noteShadeList
    }

    func deleteNote(_ rec: ShadeRecommendation) throws {
        let root = try getOrCreateAppData()
        root.noteShadeList.removeAll { $0 == rec }
        try context.save()
    }

    // MARK: - Skin Analysis

    func setUserUndertone(_ undertone: Undertone) throws {
        try updateAppData { $0.userUndertone = undertone }
    }

    func getUserUndertone() throws -> Undertone {
        try getOrCreateAppData().userUndertone
    }

    func saveSkinTone(_ skinTone: SkinTone) throws {
        context.insert(skinTone)
        try updateAppData { $0.userSkinTone = skinTone }
        try context.save()
    }

    func getSkinTone() throws -> SkinTone? {
        try getOrCreateAppData().userSkinTone
    }
}