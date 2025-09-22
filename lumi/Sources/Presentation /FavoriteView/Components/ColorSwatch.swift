//
//  ColorSwatch.swift
//  lumi
//
//  Created by Shafa Tiara Tsabita Himawan on 21/09/25.
//

import SwiftUI

struct ColorSwatch: View {
    let color: Color
    var size: CGFloat = 72

    var body: some View {
        Rectangle()
            .fill(color)
            .frame(width: size, height: size)
            .overlay(
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .stroke(Color.black.opacity(0.08), lineWidth: 1)
            )
    }
}
