//
//  DiscoverItemView.swift
//  lumi
//
//  Created by Adithya Firmansyah Putra on 23/09/25.
//

import SwiftUI
import Kingfisher

struct DiscoverItemView: View {
    let brand: String
    let product: String
    let name: String
    let imageURL: String
    let matchPercentage: Int
    let skinToneColor: Color
    let shadeColor: Color

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(brand).font(
                        .system(size: 8, weight: .semibold))
                    Text(product).font(
                        .system(size: 12, weight: .semibold))
                    Text(name).font(
                        .system(size: 10, weight: .light))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 22)
                KFImage(URL(string: imageURL))
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 70)

            }
            Text("\(matchPercentage)% Match")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 12, weight: .semibold))
            HStack(spacing: 0) {
                Rectangle().foregroundColor(skinToneColor)
                Rectangle().foregroundColor(shadeColor)
            }
            .frame(height: 6)

        }
        .padding(.vertical, 12)
    }
}
