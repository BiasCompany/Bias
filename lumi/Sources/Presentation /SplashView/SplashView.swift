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
    @State private var hasNavigated = false
    @State private var dots: String = ""
    @State private var pulse: Bool = false

    var body: some View {
        VStack {
            Spacer()
            IconAppRiveView()
                .padding(.horizontal, 80)
                .onChange(of: splashViewModel.isLoading) { oldValue, newValue in
                    // Prevent multiple navigation calls
                    guard !hasNavigated && !newValue else { return }
                    hasNavigated = true

                    // Use DispatchQueue to ensure navigation happens on the next run loop
                    DispatchQueue.main.async {
                        router.replaceNavigationPath(with: [.onboarding])
                    }
                }
            // Animated loading text with cycling dots and subtle pulse
            Text("LOADING DATA" + dots)
                .font(.system(.title3, design: .monospaced, weight: .semibold))
                .foregroundColor(.gray)
                .opacity(pulse ? 0.6 : 1.0)
                .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: pulse)
                .padding(.bottom, 80)
            Spacer()
        }
        .onAppear {
            // Start pulse animation
            pulse = true

            // Cycle dots every 0.4s up to three dots
            Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { _ in
                if dots.count >= 3 { dots = "" } else { dots.append(".") }
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
