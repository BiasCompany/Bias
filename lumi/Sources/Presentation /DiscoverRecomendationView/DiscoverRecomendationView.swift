//
//  DiscoverRecomendationView.swift.swift
//  lumi
//
//  Created by Muhammad Rifqi Syatria on 9/22/25.
//

import Kingfisher
import SwiftUI

struct DiscoverRecomendationView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var vm: DiscoverRecomendationViewModel
    @FocusState private var isFocused: Bool
    var body: some View {
        VStack(alignment: .leading) {
            BackButton()
            Text("DISCOVER MORE BRANDS FOR YOU")
            .font(Font.title2.bold().monospaced())
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 8)
            .padding(.horizontal, 16)
            
            Text("We match the shade foundation based on your skin tone and undertone, and here’s the best match for you")
                .font(Font.caption2)
                .foregroundStyle(Color("greyText"))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 8)
            .padding(.bottom, 8)
            .padding(.trailing, 16)
            .padding(.horizontal, 16)
            
            SearchView(
                searchText: $vm.searchText,
                isFocused: $isFocused,
                onCancel: {
                    vm.searchText = ""
                    isFocused = false
                }
            )
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            VStack {
                Text("\(vm.discoverRecomendation.count) Shade\(vm.discoverRecomendation.count == 1 ? "" : "s") Found")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.callout)
                ScrollView {
                    LazyVStack {
                        ForEach(vm.discoverRecomendation, id: \.id) { discover in
                            VStack {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(discover.shade.brand).font(
                                            .system(size: 8, weight: .semibold))
                                        Text(discover.shade.product).font(
                                            .system(size: 12, weight: .semibold))
                                        Text(discover.shade.name).font(
                                            .system(size: 10, weight: .light))
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.bottom, 22)
                                    KFImage(URL(string: discover.shade.image))
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxHeight: 70)

                                }
                                Text("\(discover.percentage)% Match")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.system(size: 12, weight: .semibold))
                                HStack(spacing: 0) {
                                    Rectangle().foregroundColor(discover.skinToneColor)
                                    Rectangle().foregroundColor(discover.shadeColor)
                                }
                                .frame(height: 6)

                            }
                            .onTapGesture {
                                router.navigate(to: .detailShade(shadeRecommendation: discover))
                            }
                            .padding(.vertical, 12)

                        }
                    }
                }
                .scrollIndicators(.hidden)
                .padding(.top, 12)
            }.padding(.horizontal, 16)

        }
        .navigationBarBackButtonHidden()
        .onAppear {
            vm.load()
            vm.filterRecommendations()
        }
    }
}

#Preview {

    let shade1 = Shade(
        id: UUID(),
        name: "120C",
        brand: "WARDAH",
        product: "All Hour Foundation",
        description: "Medium neutral tone foundation",
        image: "https://images.ulta.com/is/image/Ulta/2551437sw?$tn$",
        undertone: Undertone(rawValue: "cool") ?? .neutral,
        hexShade: "#D7A377",
        note: "HUHUUHUHUHUHUHU"
    )

    let shade2 = Shade(
        id: UUID(),
        name: "220W",
        brand: "Maybelline",
        product: "Fit Me Foundation",
        description: "Warm undertone shade",
        image: "https://images.ulta.com/is/image/Ulta/2551437sw?$tn$",
        undertone: Undertone(rawValue: "warm") ?? .neutral,
        hexShade: "#E1B899",
        note: "HUHUUHUHUHUHUHU"
    )

    let skinTone = SkinTone(id: UUID(), name: "Medium", hex: "#EFBF96")

    let recommendations = [
        ShadeRecommendation(
            id: UUID(), shade: shade1, skinTone: skinTone, undertone: .neutral,
            percentage: 85),
        ShadeRecommendation(
            id: UUID(), shade: shade2, skinTone: skinTone, undertone: .warm,percentage: 70),
        ShadeRecommendation(
            id: UUID(), shade: shade1, skinTone: skinTone, undertone: .cool,percentage: 60),
        ShadeRecommendation(
            id: UUID(), shade: shade1, skinTone: skinTone, undertone: .neutral,percentage: 85),
        ShadeRecommendation(
            id: UUID(), shade: shade2, skinTone: skinTone, undertone: .warm,percentage: 70),
        ShadeRecommendation(
            id: UUID(), shade: shade1, skinTone: skinTone, undertone: .cool,percentage: 60),

    ]

    // Create a VM and inject sample data for preview
    let vm = DiscoverRecomendationViewModel()
    vm.searchText = ""
    vm.discoverRecomendation = recommendations

    return DiscoverRecomendationView()
        .environmentObject(vm)
}
