//
//  ButtonActions.swift
//  bias
//
//  Created by Shafa Tiara Tsabita Himawan on 19/09/25.
//

import SwiftUI

struct BottomActionButtons: View {
    let canContinue: Bool
    let onIDK: () -> Void
    let onContinue: () -> Void

    private let buttonHeight: CGFloat = 48
    private let buttonsSpacing: CGFloat = 12
    private let bottomPadding: CGFloat = 20

    var body: some View {
        ZStack(alignment: .bottom) {
            ButtonBackdropGradient(plumeHeight: 170, bottomCap: 14)

            VStack(spacing: buttonsSpacing) {
                CustomButton(
                    title: "I DON’T KNOW MY UNDERTONE",
                    isFilled: false,
                    action: onIDK
                )
                .frame(height: buttonHeight)

                CustomButton(
                    title: "CONTINUE",
                    isFilled: true,
                    action: onContinue
                )
                .frame(height: buttonHeight)
                .opacity(canContinue ? 1 : 0.4)
                .disabled(!canContinue)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, bottomPadding)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }
}