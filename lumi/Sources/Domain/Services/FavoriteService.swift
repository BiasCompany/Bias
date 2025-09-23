//
//  FavoriteService.swift
//  lumi
//
//  Created by Muhammad Rifqi Syatria on 9/17/25.
//

protocol FavoriteService {
    func getFavorites() async throws -> [ShadeRecommendation]
}

class FavoriteServiceImpl: FavoriteService {
    
    var repo: FavoriteRepository
    
    init(repo: FavoriteRepository) {
        self.repo = repo
    }
    
    func getFavorites() async throws -> [ShadeRecommendation]  {
        return try await repo.getFavorites()
    }

}
