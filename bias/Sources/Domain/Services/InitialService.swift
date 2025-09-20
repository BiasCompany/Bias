//
//  InitialService.swift
//  bias
//
//  Created by Muhammad Rifqi Syatria on 9/17/25.
//

import Foundation

protocol InitialService {
    func initialize() async throws
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
        let existingBrands = try await repo.getBrands()

        if existingBrands.isEmpty {
            // Parse CSV to get brands
            let (brands, _) = try CSVParser.parseAllShades()
            let brandArray = Array(brands)

            // Insert all brands
            try await repo.insertAllBrand(brandArray)
            print("✅ Inserted \(brandArray.count) brands from CSV")
        } else {
            print("ℹ️ Brands already exist locally (\(existingBrands.count) brands)")
        }
    }

    func saveShadeList() async throws {
        // Check if shades already exist locally
        let existingShades = try await repo.getShades()

        if existingShades.isEmpty {
            // Parse CSV to get shades
            let (_, shades) = try CSVParser.parseAllShades()

            // Insert all shades
            try await repo.insertAllShade(shades)
            print("✅ Inserted \(shades.count) shades from CSV")
        } else {
            print("ℹ️ Shades already exist locally (\(existingShades.count) shades)")
        }
    }
}
