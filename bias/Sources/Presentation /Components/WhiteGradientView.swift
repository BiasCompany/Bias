//
//  WhiteGradientView.swift
//  bias
//
//  Created by Muhammad Rifqi Syatria on 9/19/25.
//
import SwiftUI

struct WhiteGradientView: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.white.opacity(0.0), // transparent at top
                Color.white.opacity(1.0)  // solid at bottom
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
