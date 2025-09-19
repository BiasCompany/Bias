//
//  SkinAnalysisRepository.swift
//  bias
//
//  Created by Muhammad Rifqi Syatria on 9/17/25.
//

protocol SkinAnalysisRepository {
    func saveUndertone(_ undertone: Undertone) async throws
    func getUndertone() async throws -> Undertone
    func saveSkinTone(_ skinTone: SkinTone) async throws
    func getSkinTone() async throws -> SkinTone?
}

class SkinAnalysisRepositoryImpl: SkinAnalysisRepository {
    private let ds: LocalDataSource
    init(localDataSource: LocalDataSource) { self.ds = localDataSource }

    func saveUndertone(_ undertone: Undertone) async throws {
        try await ds.setUserUndertone(undertone)
    }

    func getUndertone() async throws -> Undertone {
        return try await ds.getUserUndertone()
    }

    func saveSkinTone(_ skinTone: SkinTone) async throws {
        try await ds.saveSkinTone(skinTone)
    }

    func getSkinTone() async throws -> SkinTone? {
        return try await ds.getSkinTone()
    }
}
