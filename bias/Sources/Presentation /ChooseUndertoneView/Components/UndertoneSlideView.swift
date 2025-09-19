//
//  CarouselUndertone.swift
//  bias
//
//  Created by Shafa Tiara Tsabita Himawan on 19/09/25.
//

import SwiftUI

struct UndertoneSlideView: View {
    typealias U = ChooseUndertoneViewModel.Undertone
    let undertone: U

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 6) {
                Text(undertone.label)
                    .font(.system(size: 28, weight: .bold, design: .monospaced))
                    .foregroundColor(.black)
                    .lineLimit(1)
                Text(undertone.subtitle)
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
                    Image(undertone.assetName)
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
