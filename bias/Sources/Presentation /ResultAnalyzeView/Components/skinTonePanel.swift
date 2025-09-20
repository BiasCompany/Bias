//
//  skinTonePanel.swift
//  bias
//
//  Created by Shafa Tiara Tsabita Himawan on 20/09/25.
//

import SwiftUI

struct SkinTonePanel: View {
    var toneText: String
    var background: Color
    var onFindShade: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 6) {
                Text("YOUR SKIN TONE:")
                    .font(.system(.callout, design: .monospaced, weight: .semibold))
                    .kerning(1)
                    .foregroundColor(.black)

                Text(toneText.uppercased())
                    .font(.system(.title3, design: .monospaced, weight: .bold))
                    .foregroundColor(.black)
            }

            CustomButton(
                title: "FIND MY SHADE",
                isFilled: true,
                action: onFindShade
            )
        }
        .padding(.horizontal, 24)
        .padding(.top, 18)
        .padding(.bottom, 22)
        .frame(maxWidth: .infinity, minHeight: 200, alignment: .center)
        .background(background.ignoresSafeArea(edges: .bottom))
        .overlay(
            Rectangle()
            .stroke(Color.black, lineWidth: 2)
            .ignoresSafeArea(edges: .bottom)
        )
    }
}

#Preview("Panel only") {
    SkinTonePanel(
        toneText: "MEDIUM",
        background: Color(red: 210/255, green: 170/255, blue: 150/255)
    ) {
        print("Find my shade tapped")
    }
    .previewLayout(.sizeThatFits)
    .padding(.vertical, 8)
}
