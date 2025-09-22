//
//  SkintoneHeader.swift
//  lumi
//
//  Created by Shafa Tiara Tsabita Himawan on 21/09/25.
//

import SwiftUI

struct SkinToneHeader: View {
    let title: String
    let dateString: String
    let isExpanded: Bool
    let onToggle: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(.callout, design: .monospaced))
                    .fontWeight(.semibold)
                Text(dateString)
                    .font(.system(.caption2))
                    .italic()
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button(action: onToggle) {
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .font(.system(size: 18, weight: .semibold))
            }
            .buttonStyle(.plain)
        }
    }
}
