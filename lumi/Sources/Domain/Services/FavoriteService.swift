//
//  FavoriteService.swift
//  lumi
//
//  Created by Muhammad Rifqi Syatria on 9/17/25.
//

protocol FavoriteService {
    func getFavorites() throws -> [ShadeRecommendation]
    func getFavorite(shadeRecommendation: ShadeRecommendation) throws -> ShadeRecommendation?
    func toggleIsFavorite(shadeRecommendation: ShadeRecommendation, isFavorite: Bool) throws
}

class FavoriteServiceImpl: FavoriteService {
    
    var repo: FavoriteRepository
    
    init(repo: FavoriteRepository) {
        self.repo = repo
    }
    
    func getFavorites() throws -> [ShadeRecommendation]  {
        return try repo.getFavorites()
    }
    
    func getFavorite(shadeRecommendation: ShadeRecommendation) throws -> ShadeRecommendation? {
        try repo.getFavorite(shadeRecommendation)
    }
    
    func toggleIsFavorite(shadeRecommendation: ShadeRecommendation, isFavorite: Bool) throws {
        if isFavorite {
            try repo.saveFavorite(shadeRecommendation)
        } else {
            try repo.deleteFavorite(shadeRecommendation)
        }
    }

}
