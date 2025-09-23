//
//  SkinAnalysisViewModel.swift
//  lumi
//
//  Created by Muhammad Rifqi Syatria on 9/22/25.
//

import SwiftUI

@MainActor
final class SkinAnalysisViewModel : ObservableObject {
    var service: SkinAnalysisService = DIContainer.shared.skinAnalysisService
    var initService: InitialService = DIContainer.shared.initialService
    @Published var undertone: Undertone = Undertone.unknown
    @Published var skinTone: SkinTone?
    
    func load() {
        Task {
            skinTone = try await service.getSkinTone()
            undertone = try await service.getUndertone()
        }
    }
    
    func reset() async throws {
            try? await initService.resetAllState()
    }
    
}
