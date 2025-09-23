//
//  SplashView.swift
//  lumi
//
//  Created by Adithya Firmansyah Putra on 21/09/25.
//
import SwiftUI
import RiveRuntime

struct SplashView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var splashViewModel: SplashViewModel
    
    var body: some View {
        IconAppRiveView()
                .padding(.horizontal, 80)
        .onChange(of: splashViewModel.isLoading) { oldValue, newValue in
            if !newValue {
                if splashViewModel.isFirstTime {
                    router.replaceNavigationPath(with: [.onboarding])
                } else {
                    router.replaceNavigationPath(with: [.recommendation])
                }
            }
        }
    }
}

#Preview {
    SplashView()
        .environmentObject(Router())
        .environmentObject(SplashViewModel())
}

struct IconAppRiveView: View {
    private let rive = RiveViewModel(
        fileName: "white-logo-animation-splash",
        autoPlay: true
    )

    var body: some View {
        rive.view()
            .accessibilityHidden(true)
    }
}
