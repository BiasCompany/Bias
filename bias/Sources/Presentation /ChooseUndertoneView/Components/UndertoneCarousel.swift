//
//  UndertoneCarousel.swift
//  bias
//
//  Created by Shafa Tiara Tsabita Himawan on 19/09/25.
//

import SwiftUI

struct UndertoneCarousel: View {
    typealias U = ChooseUndertoneViewModel.Undertone
    @Binding var selected: U
    
    var body: some View {
        TabView(selection: $selected) {
            ForEach(U.allCases, id: \.self) { opt in
                UndertoneSlideView(undertone: opt)
                    .tag(opt)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .indexViewStyle(.page(backgroundDisplayMode: .never))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .top) {
            UndertonePeekLabels(current: selected) { picked in
                withAnimation(.easeInOut) { selected = picked }
            }
        }
        .overlay { EdgeFades() }
    }
}
