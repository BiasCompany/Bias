import Combine
import SwiftUI

@MainActor
final class ChooseUndertoneViewModel: ObservableObject {
    @Published var skinAnalysisService: SkinAnalysisService = DIContainer.shared.skinAnalysisService

    @Published var selected: Undertone = .neutral
    
    
    init() {
        load()
    }

    func load() {
        Task {
            do {
                selected = try await skinAnalysisService.getUndertone()
            } catch {
                print("Error loading undertone:", error)
            }
        }
    }

    func select(_ u: Undertone) {
        selected = u
    }
    
    func saveUndertone() {
        Task {
            do {
                try await skinAnalysisService.saveUndertone(selected)
            } catch {
                print("Error saving undertone:", error)
            }
        }
    }
    
}
