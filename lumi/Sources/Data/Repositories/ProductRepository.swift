//
//  ProductRepository.swift
//  lumi
//
//  Created by Shafa on 9/18/25.
//

protocol ProductRepository {
    func insertAllBrand(_ brands: [Brand]) async throws
    func getBrand() async throws -> Brand?
    func getBrands() async throws -> [Brand]
    // CRUD Shades
    func getShade() async throws -> Shade?
    func getShades() async throws -> [Shade]
    func insertAllShade(_ shades: [Shade]) async throws

    func getBrandPreference() async throws -> [Brand]
    func insertBrandPreference(_ brands: [Brand]) async throws

    func insertAllRecommendation(_ recommendations: [ShadeRecommendation]) async throws
    func getRecommendations() async throws -> [ShadeRecommendation]
    func deleteAllRecommendations() async throws
    
    func resetAllState() async throws
}

class ProductRepositoryImpl: ProductRepository {
    private let ds: LocalDataSource
    init(localDataSource: LocalDataSource) { self.ds = localDataSource }

    // MARK: - Brands
    func insertAllBrand(_ brands: [Brand]) async throws {
        try ds.setBrandsCatalog(brands)
    }

    
    func getBrand() async throws -> Brand? {
        return try ds.getBrandCatalog()
    }
    
    func getBrands() async throws -> [Brand] {
        return try ds.getBrandsCatalog()
    }

    // MARK: - Shades
    func getShade() async throws -> Shade? {
        return try ds.fetchShade()
    }
    func getShades() async throws -> [Shade] {
        return try ds.fetchShades()
    }

    func insertAllShade(_ shades: [Shade]) async throws {
        try ds.insertAllShades(shades)
    }

    // MARK: - Preferences
    func getBrandPreference() async throws -> [Brand] {
        return try ds.getUserPreferenceBrands()
    }

    func insertBrandPreference(_ brands: [Brand]) async throws {
        try ds.setUserPreferenceBrands(brands)
    }
    
    func resetAllState() async throws {
        try ds.resetState()
    }

    // MARK: - Recommendations
    func insertAllRecommendation(_ recommendations: [ShadeRecommendation]) async throws {
        try ds.insertAllRecommendations(recommendations)
    }

    func getRecommendations() async throws -> [ShadeRecommendation] {
        return try ds.fetchRecommendations()
    }

    func deleteAllRecommendations() async throws {
        try ds.deleteAllRecommendations()
    }
}
