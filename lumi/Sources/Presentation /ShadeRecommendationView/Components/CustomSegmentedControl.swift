//
//  MySegment.swift
//  lumi
//
//  Created by Adithya Firmansyah Putra on 23/09/25.
//

import SwiftUI

enum MySegment: String, CaseIterable, Identifiable {
    case brands = "BRANDS"
    case favorites = "FAVORITES"
    case notes = "NOTES"

    var id: String { self.rawValue }
}

struct CustomSegmentedControl: View {
    @Binding var selectedSegment: MySegment
    @Namespace private var namespace

    var body: some View {
        HStack {
            ForEach(MySegment.allCases) { segment in
                Text(segment.rawValue)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 8)
                    .font(.system(.caption, design: .monospaced, weight: .semibold))
                    .foregroundColor(selectedSegment == segment ? .black : Color("greyText"))
                    .background(
                        ZStack {
                            if selectedSegment == segment {
                                Rectangle()
                                    .fill(.black) // Underline color
                                    .frame(height: 3)
                                    .matchedGeometryEffect(id: "underline", in: namespace)
                                    .offset(y: 15) // Adjust position
                            }
                        }
                    )
                    .onTapGesture {
                        withAnimation(.spring()) {
                            selectedSegment = segment
                        }
                    }
            }
        }
        .background(Color.white) // Overall background
        .cornerRadius(8)
    }
}
