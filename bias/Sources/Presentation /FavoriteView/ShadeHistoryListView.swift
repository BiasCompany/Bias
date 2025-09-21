//
//  ShadeHistoryList.swift
//  bias
//
//  Created by Shafa Tiara Tsabita Himawan on 21/09/25.
//

import SwiftUI
import Kingfisher

// Dummy model
struct HistoryProduct: Identifiable {
    let id = UUID()
    let brand: String
    let productLine: String
    let shadeCode: String
    let match: Double
    let imageURL: URL?
    let shadeColor: Color
}

struct SkinToneHistoryCard: View {
    let title: String
    let dateString: String
    let swatchColor: Color
    let products: [HistoryProduct]
    @State private var isExpanded = false

    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                ColorSwatch(color: swatchColor, size: 72)
                SkinToneHeader(
                    title: title,
                    dateString: dateString,
                    isExpanded: isExpanded,
                    onToggle: { withAnimation(.easeInOut(duration: 0.2)) { isExpanded.toggle() } }
                )
            }

            if isExpanded {
                VStack(spacing: 16) {
                    ForEach(products) { p in
                        MatchProductRow(
                            brand: p.brand,
                            productLine: p.productLine,
                            shadeCode: p.shadeCode,
                            match: p.match,
                            imageURL: p.imageURL,
                            skinToneColor: swatchColor,
                            shadeColor: p.shadeColor
                        )
                        Divider()
                    }
                }
                .padding(.leading, 88)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
}

// dummy history skintone
struct ShadeHistoryListView: View {
    private let demoURL = URL(string: "https://images.ulta.com/is/image/Ulta/2300153sw?")
    private var items: [(title: String, date: String, color: Color, products: [HistoryProduct])] {
        let p1 = HistoryProduct(brand: "WARDAH", productLine: "ALL HOURS FOUNDATION", shadeCode: "120C", match: 0.96, imageURL: demoURL, shadeColor: Color(red: 210/255, green: 180/255, blue: 140/255))
        let p2 = HistoryProduct(brand: "MAYBELLINE", productLine: "FIT ME FOUNDATION", shadeCode: "220", match: 0.91, imageURL: demoURL, shadeColor: Color(red: 218/255, green: 190/255, blue: 150/255))
        return [
            ("MEDIUM SKIN TONE", "12 August 2025", Color(red: 223/255, green: 177/255, blue: 145/255), [p1, p2]),
            ("MEDIUM SKIN TONE", "11 August 2025", Color(red: 223/255, green: 177/255, blue: 145/255), [p1]),
            ("MEDIUM SKIN TONE", "10 August 2025", Color(red: 223/255, green: 177/255, blue: 145/255), [p2, p1]),
            ("MEDIUM SKIN TONE", "9 August 2025", Color(red: 223/255, green: 177/255, blue: 145/255), [p2])
        ]
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 24) {
                ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                    SkinToneHistoryCard(
                        title: item.title,
                        dateString: item.date,
                        swatchColor: item.color,
                        products: item.products
                    )
                }
            }
            .padding(.vertical, 8)
        }
        .background(Color.white)
    }
}
#Preview("Favorites Slicing") {
    FavoriteView().environmentObject(FavoriteViewModel())
}
