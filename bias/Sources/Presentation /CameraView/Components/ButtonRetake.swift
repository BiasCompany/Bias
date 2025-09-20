//
//  ButtonRetake.swift
//  bias
//
//  Created by Shafa Tiara Tsabita Himawan on 20/09/25.
//

import SwiftUI

struct ButtonRetake: View {
    var onRetake: () -> Void
    var onStartAnalysis: () -> Void
    var horizontalPadding: CGFloat = 24
    var spacing: CGFloat = 24
    var topPadding: CGFloat = 8
    var bottomPadding: CGFloat = 72 

    var body: some View {
        HStack(spacing: spacing) {
            CustomButton(title: "RETAKE", isFilled: true, action: onRetake)
                .frame(maxWidth: .infinity)

            CustomButton(title: "START ANALYSIS", isFilled: false, action: onStartAnalysis)
                .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.top, topPadding)
        .padding(.bottom, bottomPadding)
    }
}

#Preview {
    ZStack {
        Color.blue.ignoresSafeArea()
        VStack { Spacer() }
    }
    .safeAreaInset(edge: .bottom) {
        ButtonRetake(onRetake: {}, onStartAnalysis: {})
    }
}
