//
//  SplashViewModel.swift
//  lumi
//
//  Created by Adithya Firmansyah Putra on 21/09/25.
//
import SwiftUI

final class SplashViewModel: ObservableObject {
    @Published var isLoading: Bool = true
    @Published var isFirstTime: Bool = true
    @Published var initialService: InitialService = DIContainer.shared.initialService
    @Published var skinAnalysisService: SkinAnalysisService = DIContainer.shared.skinAnalysisService

    init() {
        loadInitialData()
    }
    
    func isFirstTimeLaunch() async throws-> Bool {
        try await skinAnalysisService.getSkinTone() == nil
    }

    func loadInitialData() {
        let isDataLoaded = UserDefaults.standard.bool(forKey: "isDataLoaded") 

if isDataLoaded {
    Task {
            await MainActor.run { self.isLoading = true }
            // wait 2 second
            try await Task.sleep(for: .seconds(2))
            do {
                let firstTime = try await isFirstTimeLaunch()
                await MainActor.run {
                    self.isFirstTime = firstTime
                    self.isLoading = false
                }
            } catch {
                await MainActor.run { self.isLoading = false }
                print("Initialization failed: \(error)")
            }
        }
} else {
 
        Task {
            await MainActor.run { self.isLoading = true }
            do {
                try await initialService.initialize()
                 UserDefaults.standard.set(true, forKey: "isDataLoaded")
                 await MainActor.run { self.isLoading = false }
            } catch {
                await MainActor.run { self.isLoading = false }
                print("Initialization failed: \(error)")
            }
        }
}
    

       
    }

}
