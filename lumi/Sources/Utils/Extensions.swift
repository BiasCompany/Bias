//
//  Extensions.swift
//  Spwit
//
//  Created by Adithya Firmansyah Putra on 04/08/25.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let r, g, b: UInt64
        switch hex.count {
        case 6:
            (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: 1
        )
    }
}

private extension Array {
    subscript (safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

private extension String {
    var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) }
    var trimmedNonEmpty: String? {
        let t = trimmed
        return t.isEmpty ? nil : t
    }
    func caseInsensitiveEquals(_ other: String) -> Bool {
        self.compare(other, options: [.caseInsensitive, .diacriticInsensitive]) == .orderedSame
    }
}
