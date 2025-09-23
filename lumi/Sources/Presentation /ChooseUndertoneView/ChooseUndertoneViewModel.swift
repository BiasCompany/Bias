import Combine
import SwiftUI

@MainActor
final class ChooseUndertoneViewModel: ObservableObject {
    @Published var skinAnalysisService: SkinAnalysisService
    @Published var productService: ProductService

    @Published var selected: Undertone = .neutral
    @Published var isLoading: Bool = false
    
    
    init() {
        skinAnalysisService = DIContainer.shared.skinAnalysisService
        productService = DIContainer.shared.productService
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
                isLoading = true
                try await skinAnalysisService.saveUndertone(selected)
                try await skinAnalysisService.saveSkinTone(
                    SkinTone(id: UUID(), name: "Light", hex: "#ffdbac")
                )
                try await productService.calculateMatches()
                isLoading = false
            } catch {
                isLoading = false
                print("Error saving undertone:", error)
            }
        }
    }
    
}
