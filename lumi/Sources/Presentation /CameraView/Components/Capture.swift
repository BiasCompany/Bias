//
//  Capture.swift
//  lumi
//
//  Created by Shafa Tiara Tsabita Himawan on 19/09/25.
//

import SwiftUI

public struct CaptureView: View {
    @State private var progress: Double = 0.0
    @State private var isAnimating = false
    public var onClose: (() -> Void)?

    public init(onClose: (() -> Void)? = nil) {
        self.onClose = onClose
    }

    public var body: some View {
        ZStack {
            VStack {
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 16)
                        .frame(width: 330, height: 330)

                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color("gradientA"),
                                    Color("gradientB"),
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(
                                lineWidth: 16,
                                lineCap: .round
                            )
                        )
                        .frame(width: 330, height: 330)
                        .rotationEffect(.degrees(-90))
                        .animation(.linear(duration: 3.0), value: progress)
                }
            }
        }
        .onAppear {
            startCountdown()

        }
    }

    private func startCountdown() {
        progress = 0
        withAnimation(.linear(duration: 3.0)) {
            progress = 1.0
        }
    }
}

#Preview {
    ZStack {
        Color.blue.ignoresSafeArea()
        CaptureView {
            print("Close tapped")
        }
    }
}
