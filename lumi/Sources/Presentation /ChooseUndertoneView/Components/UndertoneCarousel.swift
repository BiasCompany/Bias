//
//  UndertoneCarousel.swift
//  lumi
//
//  Created by Shafa Tiara Tsabita Himawan on 19/09/25.
//

import SwiftUI

struct UndertoneCarousel: View {
    @EnvironmentObject var vm: ChooseUndertoneViewModel

    var body: some View {
        TabView(selection: $vm.selected) {
            UndertoneSlideView(
                title: "WARM", subtitle: "Your veins color is green or olive", imageAsset: "warm"
            )
            .tag(Undertone.warm as Undertone)

            UndertoneSlideView(
                title: "NEUTRAL", subtitle: "Your veins color is green and blue",
                imageAsset: "neutral"
            )
            .tag(Undertone.neutral as Undertone)

            UndertoneSlideView(
                title: "COOL", subtitle: "Your veins color is purple or blue", imageAsset: "cool"
            )
            .tag(Undertone.cool as Undertone)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .indexViewStyle(.page(backgroundDisplayMode: .never))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .top) {
            UndertonePeekLabels()
        }
        .overlay { EdgeFades() }
    }

}
