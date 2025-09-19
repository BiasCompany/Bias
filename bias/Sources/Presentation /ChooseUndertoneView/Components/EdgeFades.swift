//
//  EdgeFades.swift
//  bias
//
//  Created by Shafa Tiara Tsabita Himawan on 19/09/25.
//

import SwiftUI

struct EdgeFades: View {
    var width: CGFloat = 100
    var body: some View {
        HStack(spacing: 0) {
            LinearGradient(colors: [.white, .white.opacity(0)],
                           startPoint: .leading, endPoint: .trailing)
                .frame(width: width)
            Spacer()
            LinearGradient(colors: [.white.opacity(0), .white],
                           startPoint: .leading, endPoint: .trailing)
                .frame(width: width)
        }
        .allowsHitTesting(false)
    }
}
