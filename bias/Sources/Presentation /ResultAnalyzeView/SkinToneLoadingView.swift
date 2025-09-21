//
//  SkinToneLoadingView.swift
//  bias
//
//  Created by Shafa Tiara Tsabita Himawan on 21/09/25.
//

import SwiftUI

struct SkinToneLoadingView: View {
    @Binding var isVisible: Bool
    
    init(isVisible: Binding<Bool>) {
        self._isVisible = isVisible
    }
    
    var body: some View {
        AnalyzingOverlay(isVisible: $isVisible)
    }
}

#Preview("SkinToneLoadingView") {
    @State var show = true
    return ZStack {
        Color.gray.opacity(0.2).ignoresSafeArea()
        VStack { 
            Text("Underlying content")
                .foregroundColor(.white)
        }
        SkinToneLoadingView(isVisible: $show)
    }
}