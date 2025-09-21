//
//  MatchProductRow.swift
//  bias
//
//  Created by Shafa Tiara Tsabita Himawan on 21/09/25.
//

import SwiftUI
import Kingfisher

struct MatchProductRow: View {
    let brand: String
    let productLine: String
    let shadeCode: String
    let match: Double
    let imageURL: URL?
    let skinToneColor: Color
    let shadeColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(brand.uppercased())
                        .font(.system(.caption2, design: .monospaced)).fontWeight(.light)
                    Text(productLine)
                        .font(.system(.caption2)).fontWeight(.semibold)
                    Text(shadeCode)
                        .font(.system(.caption2)).fontWeight(.thin)
                }
                Spacer()
                KFImage(imageURL)
                    .placeholder { Color.black.opacity(0.06) }
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 54)
                    .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
            }

            Text("\(Int(match * 100))% Match").font(.system(.caption2))
            MatchComparisonBar(
                skinToneColor: skinToneColor,
                shadeColor: shadeColor,
                height: 6
            )
        }
        .padding(.vertical, 6)
    }
}
