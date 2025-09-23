//
//  InitialService.swift
//  lumi
//
//  Created by Muhammad Rifqi Syatria on 9/17/25.
//

import Foundation

protocol InitialService {
    func initialize() async throws
    func resetAllState() async throws
}

class InitialServiceImpl: InitialService {
    private let repo: ProductRepository

    init(repo: ProductRepository) {
        self.repo = repo
    }

    func initialize() async throws {
        try await saveBrandList()
        try await saveShadeList()
    }

    func saveBrandList() async throws {
        // Check if brands already exist locally
        let existingBrands = try await repo.getBrand()

        if existingBrands == nil {
            // Parse CSV to get brands off the main actor
            let brandArray: [String] = try await Task.detached(priority: .userInitiated) {
                let (brands, _) = try CSVParser.parseAllShades()
                return Array(brands)
            }.value

            // Insert all brands
            try await repo.insertAllBrand(brandArray)
            print("✅ Inserted \(brandArray.count) brands from CSV")
        } else {
            print("ℹ️ Brands already exist locally")
        }
    }

    func saveShadeList() async throws {
        // Check if shades already exist locally
        let existingShades = try await repo.getShade()

        if existingShades == nil {
            // Parse CSV to get shades
            let (_, shades) = try CSVParser.parseAllShades()

            // Insert all shades
            try await repo.insertAllShade(shades)
            print("✅ Inserted \(shades.count) shades from CSV")
        } else {
            print("ℹ️ Shades already exist locally")
        }
    }
    
    func resetAllState() async throws {
        try await repo.resetAllState()
    }
}
