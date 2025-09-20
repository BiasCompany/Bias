//
//  ProductService.swift
//  bias
//
//  Created by Muhammad Rifqi Syatria on 9/17/25.
//

protocol ProductService {
    func getBrands() async throws -> [Brand]
    func getBrandPreference() async throws -> [Brand]
    func saveBrandPreference(_ brands: [Brand]) async throws
}

class ProductServiceImpl: ProductService {
    private let repo: ProductRepository

    init(repo: ProductRepository) {
        self.repo = repo
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
}
