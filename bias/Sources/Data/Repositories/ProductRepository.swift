//
//  ProductRepository.swift
//  bias
//
//  Created by Shafa on 9/18/25.
//

protocol ProductRepository {
    func insertAllBrand(_ brands: [Brand]) async throws
    func getBrands() async throws -> [Brand]
        // CRUD Shades
    func getShades() async throws -> [Shade]
    func insertAllShade(_ shades: [Shade]) async throws

    func getBrandPreference() async throws -> [String]
    func insertBrandPreference(_ brands: [String]) async throws

    func insertAllRecommendation(_ recommendations: [ShadeRecommendation]) async throws
    func getRecommendations() async throws -> [ShadeRecommendation]
    func deleteAllRecommendations() async throws
}

class ProductRepositoryImpl: ProductRepository {
    private let ds: LocalDataSource
    init(localDataSource: LocalDataSource) { self.ds = localDataSource }

    // MARK: - Brands
    func insertAllBrand(_ brands: [Brand]) async throws {
        try await ds.setBrandsCatalog(brands)
    }

    func getBrands() async throws -> [Brand] {
        return try await ds.getBrandsCatalog()
    }

    // MARK: - Shades
    func getShades() async throws -> [Shade] {
        return try await ds.fetchShades()
    }

    func insertAllShade(_ shades: [Shade]) async throws {
        try await ds.insertAllShades(shades)
    }

    // MARK: - Preferences
    func getBrandPreference() async throws -> [String] {
        return try await ds.getUserPreferenceBrands()
    }

    func insertBrandPreference(_ brands: [String]) async throws {
        try await ds.setUserPreferenceBrands(brands)
    }

    // MARK: - Recommendations
    func insertAllRecommendation(_ recommendations: [ShadeRecommendation]) async throws {
        try await ds.insertAllRecommendations(recommendations)
    }

    func getRecommendations() async throws -> [ShadeRecommendation] {
        return try await ds.fetchRecommendations()
    }

    func deleteAllRecommendations() async throws {
        try await ds.deleteAllRecommendations()
    }
}
// import Foundation
// import simd

// // MARK: - Models

// public struct FoundationBrand: Identifiable, Hashable {
//     public let id = UUID()
//     public let name: String
//     public init(_ name: String) { self.name = name }
// }

// public enum UndertoneCategory: String, Codable {
//     case cool = "cool"
//     case warm = "warm"
//     case neutral = "neutral"
//     case olive = "olive"
//     case unknown

//     public init(rawOrAny raw: String?) {
//         guard let r = raw?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines), !r.isEmpty else {
//             self = .unknown; return
//         }
//         self = UndertoneCategory(rawValue: r) ?? .unknown
//     }
// }

// public struct ShadeProduct: Identifiable, Hashable {
//     public let id: UUID
//     public let brand: String
//     public let product: String
//     public let name: String
//     public let hex: String?
//     public let url: String?
//     public let description: String?
//     public let undertoneCategory: UndertoneCategory
//     public let lab: SIMD3<Double>?

//     public init(
//         id: UUID = .init(),
//         brand: String,
//         product: String,
//         name: String,
//         hex: String?,
//         url: String?,
//         description: String?,
//         undertoneCategory: UndertoneCategory,
//         lab: SIMD3<Double>?
//     ) {
//         self.id = id
//         self.brand = brand
//         self.product = product
//         self.name = name
//         self.hex = hex
//         self.url = url
//         self.description = description
//         self.undertoneCategory = undertoneCategory
//         self.lab = lab
//     }
// }

// // MARK: - Protocol & Errors

// public protocol ProductRepositoryProtocol: AnyObject {
//     func loadIfNeeded() throws
//     var isLoaded: Bool { get }

//     func allBrands() -> [FoundationBrand]
//     func allProducts(brand: String) -> [String]

//     func allShades(brand: String?, product: String?) -> [ShadeProduct]
//     func searchShades(_ query: String, brand: String?) -> [ShadeProduct]
//     func shade(by id: UUID) -> ShadeProduct?
// }

// public extension ProductRepositoryProtocol {
//     func allShades() -> [ShadeProduct] {
//         allShades(brand: nil, product: nil)
//     }
//     func allShades(brand: String) -> [ShadeProduct] {
//         allShades(brand: brand, product: nil)
//     }
//     func searchShades(_ query: String) -> [ShadeProduct] {
//         searchShades(query, brand: nil)
//     }
// }

// public enum ProductRepoError: Error, LocalizedError {
//     case fileNotFound
//     case decodingFailed(line: Int)
//     case emptyData

//     public var errorDescription: String? {
//         switch self {
//         case .fileNotFound: return "CSV allShades.csv tidak ditemukan di Bundle."
//         case .decodingFailed(let line): return "Gagal parse CSV pada baris \(line)."
//         case .emptyData: return "Dataset kosong."
//         }
//     }
// }

// // MARK: - ProductRepository

// public final class ProductRepository: ProductRepositoryProtocol {
//     public static let shared = ProductRepository()

//     private var shades: [ShadeProduct] = []
//     private var byID: [UUID: ShadeProduct] = [:]
//     private var brandsIndex: [String: Set<String>] = [:]

//     public private(set) var isLoaded: Bool = false
//     private init() {}

//     // MARK: Load

//     public func loadIfNeeded() throws {
//         guard !isLoaded else { return }

//         //locate CSV
//         guard let url = Bundle.main.url(forResource: "allShades", withExtension: "csv") ??
//                         Bundle.main.url(forResource: "allShades", withExtension: nil) else {
//             throw ProductRepoError.fileNotFound
//         }

//         //read CSV
//         let raw = try String(contentsOf: url, encoding: .utf8)
//         let rows = Self.parseCSV(raw, delimiter: ";")

//         guard rows.count > 1 else { throw ProductRepoError.emptyData }

//         //build models
//         var temp: [ShadeProduct] = []
//         temp.reserveCapacity(rows.count - 1)

//         for (i, row) in rows.enumerated() where i > 0 {
//             if row.count < 5 { continue }

//             let brand        = row[safe: 1]?.trimmed ?? ""
//             let product      = row[safe: 2]?.trimmed ?? ""
//             let url          = row[safe: 3]?.trimmed
//             let description  = row[safe: 4]?.trimmed
//             let shadeName    = row[safe: 7]?.trimmed ?? ""
//             let hex          = row[safe: 10]?.trimmedNonEmpty
//             let undertoneRaw = row[safe: 14]?.trimmed

//             let lab = hex.flatMap { ColorConverter.hexToLAB($0) }
//             let item = ShadeProduct(
//                 brand: brand,
//                 product: product,
//                 name: shadeName,
//                 hex: hex,
//                 url: url,
//                 description: description,
//                 undertoneCategory: UndertoneCategory(rawOrAny: undertoneRaw),
//                 lab: lab
//             )
//             temp.append(item)
//         }

//         guard !temp.isEmpty else { throw ProductRepoError.emptyData }

//         //index
//         self.shades = temp
//         self.byID = Dictionary(uniqueKeysWithValues: temp.map { ($0.id, $0) })
//         self.brandsIndex = Self.buildBrandProductIndex(temp)
//         self.isLoaded = true
//     }

//     public func allBrands() -> [FoundationBrand] {
//         let names = brandsIndex.keys.sorted { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending }
//         return names.map(FoundationBrand.init)
//     }

//     public func allProducts(brand: String) -> [String] {
//         Array(brandsIndex[brand] ?? [])
//             .sorted { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending }
//     }

//     public func allShades(brand: String?, product: String?) -> [ShadeProduct] {
//         shades.filter { item in
//             var ok = true
//             if let b = brand { ok = ok && item.brand.caseInsensitiveEquals(b) }
//             if let p = product { ok = ok && item.product.caseInsensitiveEquals(p) }
//             return ok
//         }
//     }

//     public func searchShades(_ query: String, brand: String?) -> [ShadeProduct] {
//         let q = query.folding(options: .diacriticInsensitive, locale: .current).lowercased()
//         return shades.filter { item in
//             var hay = "\(item.brand) \(item.product) \(item.name)"
//                 .folding(options: .diacriticInsensitive, locale: .current)
//                 .lowercased()
//             if let hex = item.hex { hay += " \(hex.lowercased())" }
//             let hit = hay.contains(q)
//             if let b = brand { return hit && item.brand.caseInsensitiveEquals(b) }
//             return hit
//         }
//     }

//     public func shade(by id: UUID) -> ShadeProduct? { byID[id] }

//     private static func buildBrandProductIndex(_ items: [ShadeProduct]) -> [String: Set<String>] {
//         var dict: [String: Set<String>] = [:]
//         for s in items {
//             dict[s.brand, default: []].insert(s.product)
//         }
//         return dict
//     }

//     private static func parseCSV(_ text: String, delimiter: Character) -> [[String]] {
//         var rows: [[String]] = []
//         var row: [String] = []
//         var field = ""
//         var inQuotes = false

//         func pushField() {
//             row.append(field)
//             field = ""
//         }
//         func pushRow() {
//             rows.append(row)
//             row = []
//         }

//         for ch in text {
//             if inQuotes {
//                 if ch == "\"" {
//                     inQuotes = false
//                 } else {
//                     field.append(ch)
//                 }
//                 continue
//             }

//             switch ch {
//             case "\"":
//                 inQuotes = true
//             case delimiter:
//                 pushField()
//             case "\n", "\r":
//                 if !field.isEmpty || !row.isEmpty {
//                     pushField()
//                     pushRow()
//                 }
//             default:
//                 field.append(ch)
//             }
//         }
//         if !field.isEmpty || !row.isEmpty {
//             pushField()
//             pushRow()
//         }
//         return rows
//     }
// }

// private extension Array {
//     subscript (safe index: Int) -> Element? {
//         indices.contains(index) ? self[index] : nil
//     }
// }

// private extension String {
//     var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) }
//     var trimmedNonEmpty: String? {
//         let t = trimmed
//         return t.isEmpty ? nil : t
//     }
//     func caseInsensitiveEquals(_ other: String) -> Bool {
//         self.compare(other, options: [.caseInsensitive, .diacriticInsensitive]) == .orderedSame
//     }
// }

// // MARK: - Color conversion (sRGB D65) → CIELAB(D65)

// enum ColorConverter {
//     static func hexToLAB(_ hex: String) -> SIMD3<Double>? {
//         guard let rgb = hexToLinearSRGB(hex) else { return nil }
//         let xyz = linearSRGBtoXYZ(rgb)
//         return xyzToLabD65(xyz)
//     }

//     private static func hexToLinearSRGB(_ hex: String) -> SIMD3<Double>? {
//         var str = hex.trimmingCharacters(in: .whitespacesAndNewlines)
//         if str.hasPrefix("#") { str.removeFirst() }
//         guard str.count == 6, let val = Int(str, radix: 16) else { return nil }
//         let r = Double((val >> 16) & 0xFF) / 255.0
//         let g = Double((val >> 8) & 0xFF) / 255.0
//         let b = Double(val & 0xFF) / 255.0
//         func toLinear(_ u: Double) -> Double {
//             (u <= 0.04045) ? (u / 12.92) : pow((u + 0.055) / 1.055, 2.4)
//         }
//         return SIMD3(toLinear(r), toLinear(g), toLinear(b))
//     }

//     private static func linearSRGBtoXYZ(_ rgb: SIMD3<Double>) -> SIMD3<Double> {
//         let x = 0.4124564*rgb.x + 0.3575761*rgb.y + 0.1804375*rgb.z
//         let y = 0.2126729*rgb.x + 0.7151522*rgb.y + 0.0721750*rgb.z
//         let z = 0.0193339*rgb.x + 0.1191920*rgb.y + 0.9503041*rgb.z
//         return SIMD3(x, y, z)
//     }

//     private static func xyzToLabD65(_ xyz: SIMD3<Double>) -> SIMD3<Double> {
//         let Xn = 0.95047, Yn = 1.0, Zn = 1.08883
//         func f(_ t: Double) -> Double {
//             let e = 216.0/24389.0
//             let k = 24389.0/27.0
//             return (t > e) ? pow(t, 1.0/3.0) : ( (k * t + 16.0) / 116.0 )
//         }
//         let fx = f(xyz.x / Xn)
//         let fy = f(xyz.y / Yn)
//         let fz = f(xyz.z / Zn)
//         let L = 116.0 * fy - 16.0
//         let a = 500.0 * (fx - fy)
//         let b = 200.0 * (fy - fz)
//         return SIMD3(L, a, b)
//     }
// }
