//
//  MatchBarView.swift
//  bias
//
//  Created by Shafa Tiara Tsabita Himawan on 22/09/25.
//

import SwiftUI

struct MatchComparisonBar: View {
    let skinToneColor: Color
    let shadeColor: Color
    var height: CGFloat = 6
    var cornerRadius: CGFloat = 3
    var showsDivider: Bool = true

    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                Rectangle()
                    .fill(skinToneColor)
                    .frame(maxWidth: .infinity)
                
                Rectangle()
                    .fill(shadeColor)
                    .frame(maxWidth: .infinity)
            }
            .frame(height: height)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))

            if showsDivider {
                Rectangle()
                    .fill(Color.black.opacity(0.08))
                    .frame(width: 1, height: height)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Skin tone and shade comparison")
    }
}

