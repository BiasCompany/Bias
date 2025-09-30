//
//  FavoriteRepository.swift
//  lumi
//
//  Created by Muhammad Rifqi Syatria on 9/17/25.
//

protocol FavoriteRepository {
    func saveFavorite(_ favorite: ShadeRecommendation) throws
    func getFavorites() throws -> [ShadeRecommendation]
    func getFavorite(_ favorite: ShadeRecommendation) throws -> ShadeRecommendation?
    func updateFavorite(_ favorite: ShadeRecommendation) throws
    func deleteFavorite(_ favorite: ShadeRecommendation) throws
}

class FavoriteRepositoryImpl: FavoriteRepository {
    
    private let ds: LocalDataSource
    init(localDataSource: LocalDataSource) { self.ds = localDataSource }
    
    func saveFavorite(_ favorite: ShadeRecommendation) throws {
        try ds.saveFavorite(favorite)
    }
    
    func getFavorites() throws -> [ShadeRecommendation] {
        try ds.getFavorites()
    }
    
    func getFavorite(_ favorite: ShadeRecommendation) throws -> ShadeRecommendation? {
        try ds.getFavorites().filter { $0.id == favorite.id }.first
    }
    
    func updateFavorite(_ favorite: ShadeRecommendation) throws {
        return try ds.editFavorite(favorite)
    }
    
    func deleteFavorite(_ favorite: ShadeRecommendation) throws {
        try ds.deleteFavorite(favorite)
    }

}
