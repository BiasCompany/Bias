//
//  SplashViewModel.swift
//  bias
//
//  Created by Adithya Firmansyah Putra on 21/09/25.
//
import SwiftUI

@MainActor
final class SplashViewModel: ObservableObject {
    @Published var isLoading: Bool = true
    @Published var initialService: InitialService = DIContainer.shared.initialService
    
    init() {
        loadInitialData()
    }
    
    func loadInitialData() {
        isLoading = true
        Task {
            try? await initialService.initialize()
            isLoading = false
        }
    }
    
}
