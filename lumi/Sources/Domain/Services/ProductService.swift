//
//  ProductService.swift
//  lumi
//
//  Created by Muhammad Rifqi Syatria on 9/17/25.
//
import Foundation

protocol ProductService {
    func getBrands() async throws -> [Brand]
    func getBrandPreference() async throws -> [Brand]
    func saveBrandPreference(_ brands: [Brand]) async throws
    
    func calculateMatches() async throws
    func getShadeRecommendationFromPreferences() async throws -> [ShadeRecommendation]
    func getAllShadesRecommendation() async throws -> [ShadeRecommendation]
}

class ProductServiceImpl: ProductService {
    private let repo: ProductRepository
    private let skinAnalysisRepo: SkinAnalysisRepository

    init(repo: ProductRepository, skinAnalysisRepo: SkinAnalysisRepository) {
        self.repo = repo
        self.skinAnalysisRepo = skinAnalysisRepo
    }

    func getBrands() async throws -> [Brand] {
        return try await repo.getBrands()
    }

    func getBrandPreference() async throws -> [Brand] {
        return try await repo.getBrandPreference()
    }

    func saveBrandPreference(_ brands: [Brand]) async throws {
        try await repo.insertBrandPreference(brands)
    }

    func filterShadesFromUndertone() async throws -> [Shade] {
        var shades: [Shade] = []
        let undertone = try await skinAnalysisRepo.getUndertone()
        shades = try await repo.getShades()
        shades = shades.filter { $0.undertone == undertone }
        return shades
    }
    
    func calculateMatches() async throws {
        let undertone = try await skinAnalysisRepo.getUndertone()
        // get skintone
        guard let skinTone = try await skinAnalysisRepo.getSkinTone() else {
            return
        }
        
        guard let skinLab = ColorMath.hexToLab(skinTone.hex) else {
            return
        }
        
        // call filterShadesFromUndertone to get filtered shade
        let filteredShades: [Shade] = try await filterShadesFromUndertone()
        
        // calculate each skintone into hex shade and get the deltaE
        let computedShades = filteredShades.compactMap { shade -> ShadeRecommendation? in
            guard let shadeLab = ColorMath.hexToLab(shade.hexShade) else { return nil }
            let dE = ColorMath.ciede2000(skinLab, shadeLab)
            // map into deltaE into percentage
            let pct = matchPercentage(for: dE)
            return ShadeRecommendation(id: UUID(), shade: shade, skinTone: skinTone, undertone: undertone, percentage: pct)
        }
        // return as shade recommendation to input the data that we need
        let filteredAndSorted = computedShades
            // filterThresholdRecommendation
            .filter { $0.percentage >= 60 }
            .sorted { $0.percentage > $1.percentage }
        
        try await repo.deleteAllRecommendations()
        try await repo.insertAllRecommendation(filteredAndSorted)
    }
    
    func getShadeRecommendationFromPreferences() async throws -> [ShadeRecommendation] {
        // 1) Get brand preferences
        let preferredBrands = try await repo.getBrandPreference()

        // 2) Get all recommendations
        let allRecs = try await repo.getRecommendations()

        // 3) Filter by brand preference
        let filtered = allRecs.filter { rec in
            preferredBrands.contains(rec.shade.brand)
        }

        // 4) Perhaps return sorted by percentage descending
        return filtered.sorted { $0.percentage > $1.percentage }
    }
    
    func getAllShadesRecommendation() async throws -> [ShadeRecommendation] {
        return try await repo.getRecommendations()
    }

    private func matchPercentage(for dE: Double) -> Int {
        // Continuous piecewise without branching, clamped to 0–100:
        // 0 - 5 = 100 - 80
        // 5 - dst 
        let seg1 = min(max(dE, 0.0), 2.0)
        let seg2 = min(max(dE - 2.0, 0.0), 1.0)
        let seg3 = min(max(dE - 3.0, 0.0), 2.0)
        let raw = 100.0 - 5.0 * seg1 - 10.0 * seg2 - 40.0 * seg3
        let value = min(max(raw, 0.0), 100.0)
        return Int(round(value))
    }
}

