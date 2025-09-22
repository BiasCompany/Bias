//
//  SkinAnalysisService.swift
//  bias
//
//  Created by Muhammad Rifqi Syatria on 9/17/25.
//

protocol SkinAnalysisService {
    func saveUndertone(_ undertone: Undertone) async throws
    func getUndertone() async throws -> Undertone
    func saveSkinTone(_ skinTone: SkinTone) async throws
    func getSkinTone() async throws -> SkinTone?
}

class SkinAnalysisServiceImpl: SkinAnalysisService {
    private let repo: SkinAnalysisRepository
   
    init(repo: SkinAnalysisRepository) {
        self.repo = repo
    }
    
    func saveUndertone(_ undertone: Undertone) async throws {
        try await repo.saveUndertone(undertone)
    }
    
    func getUndertone() async throws -> Undertone {
        try await repo.getUndertone()
    }
    
    func saveSkinTone(_ skinTone: SkinTone) async throws {
        try await repo.saveSkinTone(skinTone)
    }
    
    func getSkinTone() async throws -> SkinTone? {
        try await repo.getSkinTone()
    }
}
