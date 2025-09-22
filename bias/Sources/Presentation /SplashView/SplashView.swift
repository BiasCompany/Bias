//
//  SplashView.swift
//  bias
//
//  Created by Adithya Firmansyah Putra on 21/09/25.
//
import SwiftUI

struct SplashView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var splashViewModel: SplashViewModel
    @State private var hasNavigated = false

    var body: some View {
        ProgressView()
            .onChange(of: splashViewModel.isLoading) { oldValue, newValue in
                // Prevent multiple navigation calls
                guard !hasNavigated && !newValue else { return }
                hasNavigated = true

                // Use DispatchQueue to ensure navigation happens on the next run loop
                DispatchQueue.main.async {
                    router.replaceNavigationPath(with: [.onboarding])
                }
            }
    }
}
