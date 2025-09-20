//
//  Incomplete.swift
//  bias
//
//  Created by Shafa Tiara Tsabita Himawan on 20/09/25.
//


import SwiftUI

struct Incomplete: View {
    var onRetake: () -> Void

    private let circleSize: CGFloat = 100

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            VStack(spacing: 24) {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: circleSize, height: circleSize)
                        .shadow(color: .black.opacity(0.35), radius: 12, x: 0, y: 6)

                    Image(systemName: "xmark")
                        .font(.system(size: circleSize * 0.38, weight: .bold))
                        .foregroundColor(.black)
                }
                .padding(.top, 180)

                Text("ANALYSIS INCOMPLETE")
                    .font(.system(.title2, design: .monospaced, weight: .semibold))
                    .kerning(1)
                    .foregroundColor(.white)

                Text("Can not detect skin tone,\ntry to take your photo again!")
                    .font(.system(.callout, weight: .regular))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)

                Spacer(minLength: 0)
            }
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                CustomButton(title: "RETAKE", isFilled: false, action: onRetake)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 14)
            .padding(.bottom, 280)
        }
    }
}

#Preview {
    Incomplete(onRetake: {})
}
