//
//  BrandView.swift
//  lumi
//
//  Created by Adithya Firmansyah Putra on 23/09/25.
//

import SwiftUI
import Foundation

struct BrandView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var viewModel: ShadeRecommendationViewModel
    
    @State private var currentIndex: Int = 0
    @State private var timer: Timer? = nil

    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            Text("RECOMMENDED FOR YOU")
            .font(Font.title2.bold().monospaced())
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 8)
            
            Text("Based on your Fair Skin Tone, here’s the foundation recommendation shades to complement your natural beauty.")
                .font(Font.caption2)
                .foregroundStyle(Color("greyText"))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 12)
            
            HStack {
                Text(!viewModel.shadesRecommendationBrandPreference.isEmpty ? "YOUR PREFERENCES" : "BEST MATCHES")
                    .font(Font.callout.monospaced().weight(.semibold))
                Spacer()
                Button(action: {
                    router.navigate(to: .brandPreference(isEdit: true))
                }) {
                    Text("Edit")
                        .font(Font.caption2)
                        .foregroundStyle(Color("greyText"))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 12)
            
            // Determine data source: prefer brand preference when available
            let dataSource: [ShadeRecommendation] = !viewModel.shadesRecommendationBrandPreference.isEmpty ? viewModel.shadesRecommendationBrandPreference : viewModel.shadesRecommendation

            if viewModel.isLoading {
                ProgressView("Loading recommendations…")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 12)
            }
            
                TabView(selection: $currentIndex) {
                    ForEach(Array(dataSource.enumerated()), id: \.offset) { index, match in
                        BestMatch(product: match)
                            .onTapGesture {
                                router.navigate(to: .detailShade(shadeRecommendation: match))
                            }
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: 300)
                .padding(.horizontal, -16)
                .onAppear {
                    // Trigger loading when this view appears
                    viewModel.load()
                    // Invalidate an existing timer if any
                    timer?.invalidate()
                    // Auto-advance every 3 seconds
                    timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
                        withAnimation(.easeInOut) {
                            currentIndex = (currentIndex + 1) % max(dataSource.count, 1)
                        }
                    }
                }
                .onDisappear {
                    timer?.invalidate()
                    timer = nil
                }

                // Dots indicator
                HStack(spacing: 6) {
                    ForEach(dataSource.indices, id: \.self) { index in
                        Rectangle()
                            .fill(index == currentIndex ? Color.black : Color.gray.opacity(0.3))
                            .frame(width: 6, height: 6)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 8)
            
            
            HStack {
                Text("DISCOVER MORE")
                    .font(Font.callout.monospaced().weight(.semibold))
                Spacer()
                Button(action: {
                    router.navigate(to: .allShades)
                }) {
                    Text("See All")
                        .font(Font.caption2)
                        .foregroundStyle(Color("greyText"))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                let rows = [
                    GridItem(.fixed(120), spacing: 12),
                    GridItem(.fixed(120), spacing: 12)
                ]
                LazyHGrid(rows: rows) {
                    ForEach(dataSource.indices, id: \.self) { index in
                        let item = dataSource[index]
                        DiscoverItemView(
                            brand: item.shade.brand,
                            product: item.shade.product,
                            name: item.shade.name,
                            imageURL: item.shade.image,
                            matchPercentage: item.percentage,
                            skinToneColor: item.skinToneColor,
                            shadeColor: item.shadeColor
                        )
                        .onTapGesture {
                            router.navigate(to: .detailShade(shadeRecommendation: item))
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.72)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                    }
                }
                .padding(.top, 4)
            }
            .padding(.horizontal, -16)
        }
    }
}
