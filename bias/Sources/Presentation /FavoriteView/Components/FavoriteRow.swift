//
//  FavoriteRow.swift
//  bias
//
//  Created by Shafa Tiara Tsabita Himawan on 21/09/25.
//
// Presentation/Components/FavoriteRow.swift
import SwiftUI
import Kingfisher

struct FavoriteRow: View {
    let rec: ShadeRecommendation

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 12) {
                ColorSwatch(color: rec.displaySkinToneColor, size: 48)

                VStack(alignment: .leading, spacing: 2) {
                    Text(rec.displayBrand.uppercased())
                        .font(.system(.callout)).fontWeight(.semibold)
                    Text(rec.displayProductLine)
                        .font(.system(.title3)).fontWeight(.bold)
                    Text(rec.displayShadeCode)
                        .font(.system(.footnote, design: .monospaced))
                        .foregroundStyle(.secondary)
                }
                Spacer()
                KFImage(rec.displayImageURL)
                    .placeholder { Color.black.opacity(0.06) }
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 54)
                    .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
            }

            Text("\(Int(rec.displayMatch * 100))% Match")
                .font(.system(.callout))

            MatchComparisonBar(
                skinToneColor: rec.displaySkinToneColor,
                shadeColor: rec.displayShadeColor,
                height: 6
            )
        }
    }
}
