//
//  InfoBanner.swift
//  bias
//
//  Created by Shafa Tiara Tsabita Himawan on 19/09/25.
//
import SwiftUI

struct InfoBanner: View {
    let text: String

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Image(systemName: "info.circle")
                .font(.system(size: 18, weight: .semibold))
                .frame(width: 22, height: 22, alignment: .center)

            Text(text)
                .font(.system(size: 11, weight: .regular))
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color("creamLabel"))
    }
}
