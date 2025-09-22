//
//  CarouselUndertone.swift
//  bias
//
//  Created by Shafa Tiara Tsabita Himawan on 19/09/25.
//

import SwiftUI

struct UndertoneSlideView: View {
    let title: String
    let subtitle: String
    let imageAsset: String

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 6) {
                Text(title)
                    .font(.system(size: 28, weight: .bold, design: .monospaced))
                    .foregroundColor(.black)
                    .lineLimit(1)
                Text(subtitle)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.black.opacity(0.7))
            }
            .frame(height: 64)
            .padding(.top, 8)

            GeometryReader { geo in
                ZStack {
                    Image("hands")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                    Image(imageAsset)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                        .allowsHitTesting(false)
                        .transition(.opacity)
                }
                .padding(.horizontal, 12)
            }
        }
    }
}
