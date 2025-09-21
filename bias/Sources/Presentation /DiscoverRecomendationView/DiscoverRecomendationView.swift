//
//  DiscoverRecomendationView.swift.swift
//  bias
//
//  Created by Muhammad Rifqi Syatria on 9/22/25.
//

import SwiftUI
import Kingfisher
struct DiscoverRecomendationView: View {
    @EnvironmentObject var vm : DiscoverRecomendationViewModel
    @FocusState private var isFocused: Bool
    var body: some View {
        VStack(alignment: .leading){
            HeaderView(
                searchText: $vm.searchText,
                isFocused: $isFocused,
                onCancel: {},
                onToggleAll: {},
                isAllSelected: true
            )
            VStack{
                Text("256 Shade Found")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.callout)
                ScrollView{
                    LazyVStack{
                        ForEach(vm.discoverRecomendation){ discover in
                            VStack(){
                                HStack{
                                    VStack(alignment: .leading){
                                        Text(discover.shade.brand).font(.system(size: 8, weight: .semibold))
                                        Text(discover.shade.product).font(.system(size: 12, weight: .semibold))
                                        Text(discover.shade.name).font(.system(size: 10, weight: .light))
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.bottom, 22)
                                    KFImage(URL(string: discover.shade.image))
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: .infinity, maxHeight: 70)
                                    
                                }
                                Text("\(discover.percentage)% Match")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.system(size: 12, weight: .semibold))
                                HStack(spacing: 0){
                                    Rectangle().foregroundColor(vm.skinToneColor)
                                    Rectangle().foregroundColor(vm.shadeColor)
                                }
                                .frame(height: 6)
                                
                            }
                            .padding(.vertical, 12)
                            
                        }
                    }
                }
                .padding(.top,12)
            }.padding(.horizontal, 16)
            
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
            hexShade: "#D7A377"
        )

        let shade2 = Shade(
            id: UUID(),
            name: "220W",
            brand: "Maybelline",
            product: "Fit Me Foundation",
            description: "Warm undertone shade",
            image: "https://images.ulta.com/is/image/Ulta/2300153sw?$tn$",
            undertone: Undertone(rawValue: "warm") ?? .neutral,
            hexShade: "#E1B899"
        )

        let skinTone = SkinTone(id: UUID(), name: "Medium", hex: "#EFBF96")

        let recommendations = [
            ShadeRecommendation(id: UUID(), shade: shade1, skinTone: skinTone, undertone: .neutral, notes: "Ini product oke sih, shade nya oke, texture nya juga okay, ga gampang oksidasi, udah punya juga kok", percentage: 85),
            ShadeRecommendation(id: UUID(), shade: shade2, skinTone: skinTone, undertone: .warm, notes: "Agak terlalu warm untukku, tapi masih masuk.", percentage: 70),
            ShadeRecommendation(id: UUID(), shade: shade1, skinTone: skinTone, undertone: .cool, notes: "bagus banget inininiinisanksnaksaks", percentage: 60),
            ShadeRecommendation(id: UUID(), shade: shade1, skinTone: skinTone, undertone: .neutral, notes: "Ini product oke sih, shade nya oke, texture nya juga okay, ga gampang oksidasi, udah punya juga kok", percentage: 85),
            ShadeRecommendation(id: UUID(), shade: shade2, skinTone: skinTone, undertone: .warm, notes: "Agak terlalu warm untukku, tapi masih masuk.", percentage: 70),
            ShadeRecommendation(id: UUID(), shade: shade1, skinTone: skinTone, undertone: .cool, notes: "bagus banget inininiinisanksnaksaks", percentage: 60),

        ]
    let vm = DiscoverRecomendationViewModel(shadeRecomendations: recommendations)
    
    return DiscoverRecomendationView()
        .environmentObject(vm)
}
