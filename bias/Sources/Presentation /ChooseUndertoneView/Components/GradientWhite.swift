//
//  ButtonBackdropGradient.swift
//  bias
//
//  Created by Adithya Firmansyah Putra on 20/09/25.
//


//
//  GradientWhite.swift
//  bias
//
//  Created by Shafa Tiara Tsabita Himawan on 19/09/25.
//

import SwiftUI

struct ButtonBackdropGradient: View {
    var plumeHeight: CGFloat = 160
    var bottomCap: CGFloat = 20

    var body: some View {
        VStack(spacing: 0) {
            LinearGradient(colors: [.white, .white.opacity(0)],
                           startPoint: .bottom, endPoint: .top)
                .frame(height: plumeHeight)

            Rectangle()
                .fill(Color.white)
                .frame(height: bottomCap)
        }
        .frame(maxWidth: .infinity, alignment: .bottom)
        .ignoresSafeArea(.container, edges: .bottom)
        .allowsHitTesting(false)
    }
}