import SwiftData
import Foundation

// MARK: - LocalDataSource

@MainActor
final class LocalDataSource {

    // MARK: Lifecycle

    let container: ModelContainer
    var context: ModelContext { container.mainContext }

    /// Create with an existing container (recommended: pass from your App)
    init(container: ModelContainer) {
        self.container = container
    }

    /// Convenience factory that builds a default container for all models
    static func makeDefaultContainer(isStoredInMemory: Bool = false) throws -> ModelContainer {
        let schema = Schema([
            AppData.self,
            Shade.self,
            SkinTone.self,
            ShadeRecommendation.self
        ])
        let conf = ModelConfiguration(isStoredInMemory: isStoredInMemory)
        return try ModelContainer(for: schema, configurations: conf)
    }

    // MARK: - AppData (singleton-ish root)

    /// Ensure a single AppData exists; creates one if missing.
    func getOrCreateAppData() throws -> AppData {
        let fetch = FetchDescriptor<AppData>(predicate: nil, sortBy: [])
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

    // MARK: - Shades

    @discardableResult
    func createShade(
        name: String,
        brand: Brand,
        product: String,
        description: String,
        image: String,
        undertone: Undertone,
        hexShade: String
    ) throws -> Shade {
        let shade = Shade(
            name: name,
            brand: brand,
            product: product,
            description: description,
            image: image,
            undertone: undertone,
            hexShade: hexShade
        )
        context.insert(shade)

        // also keep a flat list in AppData if you want that mirror
        let root = try getOrCreateAppData()
        root.shades.append(shade)

        try context.save()
        return shade
    }

    func fetchShades(
        brand: Brand? = nil,
        undertone: Undertone? = nil,
        search: String? = nil
    ) throws -> [Shade] {
        var predicates: [Predicate<Shade>] = []
        if let brand { predicates.append(#Predicate { $0.brand == brand }) }
        if let undertone { predicates.append(#Predicate { $0.undertone == undertone }) }
        if let s = search, !s.isEmpty {
            predicates.append(#Predicate { $0.name.localizedStandardContains(s) || $0.product.localizedStandardContains(s) })
        }

        let predicate: Predicate<Shade>? = predicates.isEmpty
            ? nil
            : predicates.dropFirst().reduce(predicates.first!) { acc, next in #Predicate { acc($0) && next($0) } }

        let sort: [SortDescriptor<Shade>] = [SortDescriptor(\.brand, order: .forward),
                                             SortDescriptor(\.product, order: .forward),
                                             SortDescriptor(\.name, order: .forward)]
        let fd = FetchDescriptor<Shade>(predicate: predicate, sortBy: sort)
        return try context.fetch(fd)
    }

    func updateShade(_ shade: Shade, apply: (Shade) -> Void) throws {
        apply(shade)
        try context.save()
    }

    func deleteShade(_ shade: Shade) throws {
        context.delete(shade)
        try context.save()
    }

    // MARK: - SkinTone

    @discardableResult
    func createSkinTone(name: String, hex: String, date: Date = .now) throws -> SkinTone {
        let st = SkinTone(name: name, hex: hex, date: date)
        context.insert(st)

        // Optionally set as user's current skin tone
        let root = try getOrCreateAppData()
        root.userSkinTone = st

        try context.save()
        return st
    }

    func fetchSkinTones(limit: Int? = nil) throws -> [SkinTone] {
        var fd = FetchDescriptor<SkinTone>(sortBy: [SortDescriptor(\.date, order: .reverse)])
        if let limit { fd.fetchLimit = limit }
        return try context.fetch(fd)
    }

    func updateSkinTone(_ skinTone: SkinTone, apply: (SkinTone) -> Void) throws {
        apply(skinTone)
        try context.save()
    }

    func deleteSkinTone(_ skinTone: SkinTone) throws {
        // Clear from AppData if it matches current
        let root = try getOrCreateAppData()
        if root.userSkinTone == skinTone { root.userSkinTone = nil }
        context.delete(skinTone)
        try context.save()
    }

    // MARK: - Shade Recommendations

    @discardableResult
    func createRecommendation(
        shade: Shade,
        skinTone: SkinTone,
        undertone: Undertone,
        notes: String = "",
        percentage: Int = 0
    ) throws -> ShadeRecommendation {
        let rec = ShadeRecommendation(
            shade: shade,
            skinTone: skinTone,
            undertone: undertone,
            notes: notes,
            lastUpdatedNote: .now,
            percentage: percentage
        )
        context.insert(rec)

        let root = try getOrCreateAppData()
        root.shadeRecommendationList.append(rec)

        try context.save()
        return rec
    }

    func fetchRecommendations(
        forShade shade: Shade? = nil,
        minPercentage: Int? = nil,
        onlyFavorites: Bool = false,
        onlyNotes: Bool = false
    ) throws -> [ShadeRecommendation] {
        let root = try getOrCreateAppData()
        var base = try context.fetch(FetchDescriptor<ShadeRecommendation>(
            sortBy: [SortDescriptor(\.percentage, order: .reverse),
                     SortDescriptor(\.lastUpdatedNote, order: .reverse)]
        ))

        if let shade { base = base.filter { $0.shade == shade } }
        if let minP { base = base.filter { $0.percentage >= minP } }
        if onlyFavorites { base = base.filter { root.favoriteShadeList.contains($0) } }
        if onlyNotes { base = base.filter { root.noteShadeList.contains($0) } }
        return base
    }

    func updateRecommendation(_ rec: ShadeRecommendation, apply: (ShadeRecommendation) -> Void) throws {
        apply(rec)
        rec.lastUpdatedNote = .now
        try context.save()
    }

    func deleteRecommendation(_ rec: ShadeRecommendation) throws {
        // Remove from mirror lists in AppData if present
        let root = try getOrCreateAppData()
        root.shadeRecommendationList.removeAll { $0 == rec }
        root.favoriteShadeList.removeAll { $0 == rec }
        root.noteShadeList.removeAll { $0 == rec }

        context.delete(rec)
        try context.save()
    }

    // MARK: - Favorites / Notes helpers (AppData mirrors)

    func toggleFavorite(_ rec: ShadeRecommendation, isFavorite: Bool) throws {
        let root = try getOrCreateAppData()
        if isFavorite {
            if !root.favoriteShadeList.contains(rec) { root.favoriteShadeList.append(rec) }
        } else {
            root.favoriteShadeList.removeAll { $0 == rec }
        }
        try context.save()
    }

    func addToNotes(_ rec: ShadeRecommendation) throws {
        let root = try getOrCreateAppData()
        if !root.noteShadeList.contains(rec) { root.noteShadeList.append(rec) }
        try context.save()
    }

    func removeFromNotes(_ rec: ShadeRecommendation) throws {
        let root = try getOrCreateAppData()
        root.noteShadeList.removeAll { $0 == rec }
        try context.save()
    }

    // MARK: - Brands & preferences

    func setUserUndertone(_ undertone: Undertone) throws {
        try updateAppData { $0.userUndertone = undertone }
    }

    func setUserPreferenceBrands(_ brands: [String]) throws {
        try updateAppData { $0.userPreferenceBrands = brands }
    }

    func setBrandsCatalog(_ brands: [Brand]) throws {
        try updateAppData { $0.brands = brands }
    }
}
