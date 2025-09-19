//
//  FavoriteRepository.swift
//  bias
//
//  Created by Muhammad Rifqi Syatria on 9/17/25.
//


protocol FavoriteRepository {
    func saveFavorite(_ favorite: ShadeRecommendation) async throws
    func getFavorites() async throws -> [ShadeRecommendation]
    func deleteFavorite(_ favorite: ShadeRecommendation) async throws
}

class FavoriteRepositoryImpl: FavoriteRepository {
    private let ds: LocalDataSource
    init(localDataSource: LocalDataSource) { self.ds = localDataSource }

    func saveFavorite(_ favorite: ShadeRecommendation) async throws {
        try await ds.saveFavorite(favorite)
    }

    func getFavorites() async throws -> [ShadeRecommendation] {
        return try await ds.getFavorites()
    }

    func deleteFavorite(_ favorite: ShadeRecommendation) async throws {
        try await ds.deleteFavorite(favorite)
    }
}
