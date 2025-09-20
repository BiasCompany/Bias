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
    
    var body: some View {
        if splashViewModel.isLoading {
            ProgressView()
        } else {
            Color.clear
                .onAppear {
                    router.replaceNavigationPath(with: [.onboarding])
                }
        }
    }
}
