//
//  BestMatches.swift
//  lumi
//
//  Created by Shafa Tiara Tsabita Himawan on 22/09/25.
//

import Kingfisher
import SwiftUI

struct BestMatch: View {
    let product: ShadeRecommendation
    @StateObject private var viewModel: ShadeRecommendationViewModel

    init(product: ShadeRecommendation) {
        self.product = product
        self._viewModel = StateObject(
            wrappedValue: ShadeRecommendationViewModel(recommendation: product))
    }

    private var skinToneColor: Color {
        Color(hex: product.skinTone.hex) ?? .gray
    }

    private var shadeColor: Color {
        Color(hex: product.shade.hexShade) ?? .gray
    }

    private var matchPercentage: Int {
        product.percentage
    }

    private var undertoneText: String {
        product.shade.undertone.rawValue.capitalized
    }

    var body: some View {
        HStack(spacing: 16) {
            VStack(spacing: 8) {
                KFImage(URL(string: product.shade.image))
                    .placeholder { Rectangle().fill(Color.gray) }
                    .resizable()
                    .scaledToFit()
                    .clipShape(Rectangle())

                VStack(spacing: 0) {
                    Rectangle()
                        .fill(skinToneColor)
                        .frame(height: 48)
                        .overlay(
                            Text("Medium Skin Tone")
                                .font(.system(.caption2))
                                .fontWeight(.thin)
                                .foregroundColor(.black)
                                .lineLimit(1)
                        )

                    Rectangle()
                        .fill(shadeColor)
                        .frame(height: 48)
                        .overlay(
                            Text("\(product.shade.name) (\(undertoneText) Undertone)")
                                .font(.system(.caption2))
                                .fontWeight(.thin)
                                .foregroundColor(.black)
                                .lineLimit(1)
                        )
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.40)
            .padding(.leading, 16)
            .padding(.vertical, 16)

            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(product.shade.brand.uppercased())
                        .font(.system(.caption2, design: .monospaced))
                        .fontWeight(.regular)
                        .foregroundColor(.black)

                    Text(product.shade.product)
                        .font(.system(.caption))
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                }
                .padding(.bottom, 26)
                Text(product.shade.name)
                    .font(.system(.caption2))
                    .fontWeight(.regular)
                    .foregroundColor(.black)

                Spacer()

                // Match Information with Heart Icon
                HStack {
                    VStack(alignment: .leading, spacing: 1) {
                        Text("\(matchPercentage)% Match your shade")
                            .font(.system(.caption2))
                            .fontWeight(.regular)
                            .foregroundColor(.black)
                    }
                    .padding(.bottom, 28)

                    Spacer()
                    Button {
                        if viewModel.isFavorite {
                            viewModel.showUnfavoriteAlert = true
                        } else {
                            viewModel.toggleFavorite()
                        }
                    } label: {
                        Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(viewModel.isFavorite ? .red : .black)
                    }
                    .padding(.bottom, 28)
                    .confirmationDialog(
                        "Remove Favorite?",
                        isPresented: $viewModel.showUnfavoriteAlert,
                        titleVisibility: .visible
                    ) {
                        Button("Remove", role: .destructive) {
                            viewModel.confirmRemoveFavorite()
                        }
                        Button("Cancel", role: .cancel) {}
                    } message: {
                        Text(
                            "If your skin tone changes, you might not be able to add this product again after deleting it."
                        )
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.trailing, 16)
            .padding(.vertical, 16)
        }
        .frame(height: 322)
        .background(Color.white)
        //        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }

}

struct BestMatches: View {
    let matches: [ShadeRecommendation]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Best Matches")
                .font(.system(.title2, design: .monospaced))
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.horizontal, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(matches) { match in
                        BestMatch(product: match)
                            .frame(width: 280)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

#Preview("Best Match Card") {
    BestMatch(
        product: ShadeRecommendation(
            id: UUID(),
            shade: Shade(
                id: UUID(),
                name: "120C",
                brand: "WARDAH",
                product: "ALL HOURS FOUNDATION",
                description: "Medium skin tone foundation",
                image: "https://images.ulta.com/is/image/Ulta/2551437sw?$tn$",
                undertone: .neutral,
                hexShade: "#D2B48C"
            ),
            skinTone: SkinTone(
                id: UUID(),
                name: "Medium",
                hex: "#E8B191",
                date: .now
            ),
            undertone: .neutral,
            notes: "",
            lastUpdatedNote: .now,
            percentage: 99
        )
    )
    .padding()
}

#Preview("Best Matches List") {
    BestMatches(matches: [
        ShadeRecommendation(
            id: UUID(),
            shade: Shade(
                id: UUID(),
                name: "120C",
                brand: "WARDAH",
                product: "ALL HOURS FOUNDATION",
                description: "Medium skin tone foundation",
                image: "https://images.ulta.com/is/image/Ulta/2551437sw?$tn$",
                undertone: .neutral,
                hexShade: "#D2B48C"
            ),
            skinTone: SkinTone(
                id: UUID(),
                name: "Medium",
                hex: "#E8B191",
                date: .now
            ),
            undertone: .neutral,
            notes: "",
            lastUpdatedNote: .now,
            percentage: 99
        ),
        ShadeRecommendation(
            id: UUID(),
            shade: Shade(
                id: UUID(),
                name: "220",
                brand: "MAYBELLINE",
                product: "FIT ME FOUNDATION",
                description: "Medium skin tone foundation",
                image: "https://images.ulta.com/is/image/Ulta/2551437sw?$tn$",
                undertone: .warm,
                hexShade: "#D4B896"
            ),
            skinTone: SkinTone(
                id: UUID(),
                name: "Medium",
                hex: "#E8B191",
                date: .now
            ),
            undertone: .warm,
            notes: "",
            lastUpdatedNote: .now,
            percentage: 95
        ),
    ])
    .padding()
}
