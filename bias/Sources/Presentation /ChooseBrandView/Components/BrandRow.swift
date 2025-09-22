//
//  BrandRow.swift
//  bias
//
//  Created by Adithya Firmansyah Putra on 21/09/25.
//
import SwiftUI

struct BrandRow: View {
    let title: String
    let isSelected: Bool
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(.primary)
            Spacer()
            if isSelected {
                Image(systemName: "checkmark")
                    .font(.body.weight(.semibold))
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 16)
    }
}
