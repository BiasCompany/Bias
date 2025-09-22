//
//  Analyzing.swift
//  lumi
//
//  Created by Shafa Tiara Tsabita Himawan on 21/09/25.
//

import RiveRuntime
import SwiftUI

struct SparkleRiveView: View {
    private let rive = RiveViewModel(
        fileName: "sparkle-progress",
        autoPlay: true
    )

    var body: some View {
        rive.view()
            .accessibilityHidden(true)
    }
}

public struct AnalyzingView: View {
    public init() {}
    public var body: some View {
        BaseAnalyzingContent()
    }
}

public struct AnalyzingOverlay: View {
    @Binding var isVisible: Bool

    public init(isVisible: Binding<Bool>) {
        self._isVisible = isVisible
    }

    public var body: some View {
        Group {
            if isVisible { BaseAnalyzingContent() }
        }
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.2), value: isVisible)
        .accessibilityLabel("Processing. Analyzing your skin tone.")
    }
}

private struct BaseAnalyzingContent: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 24) {
                SparkleRiveView()
                    .frame(width: 72, height: 72)
                VStack(spacing: 12) {
                    Text("PROCESSING…")
                        .font(.title2.monospaced())
                        .fontWeight(.semibold)
                        .kerning(2)
                        .foregroundStyle(.white)
                    Text("Analyzing your skin tone")
                        .font(.callout)
                        .fontWeight(.regular)
                        .foregroundStyle(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
            }
        }
    }
}

#Preview("Analyzing – Overlay") {
    @State var show = true
    return ZStack {
        Color.gray.opacity(0.2).ignoresSafeArea()
        VStack { Text("Underlying content") }
        AnalyzingOverlay(isVisible: $show)
    }
}
