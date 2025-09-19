//
//  UndertonePeekLebel.swift
//  bias
//
//  Created by Shafa Tiara Tsabita Himawan on 19/09/25.
//
//
//import SwiftUI
//
//struct UndertonePeekLabels: View {
//    typealias U = ChooseUndertoneViewModel.Undertone
//    let current: U
//    var onSelect: (U) -> Void
//
//    private let fullWidth: CGFloat = 110
//    private let partialWidth: CGFloat = 64
//    private let sidePadding: CGFloat = 16
//
//    var body: some View {
//        let all = U.allCases
//        let idx = all.firstIndex(of: current)!
//        let left: U?  = idx > 0 ? all[idx - 1] : nil
//        let right: U? = idx < all.count - 1 ? all[idx + 1] : nil
//
//        HStack(alignment: .firstTextBaseline) {
//            // LEFT
//            if let l = left {
//                let isNeutralTail = (current == .warm && l == .neutral)
//                PeekClipText(
//                    l.label,
//                    width: isNeutralTail ? partialWidth : fullWidth,
//                    align: isNeutralTail ? .trailing : .leading
//                )
//                .padding(.leading, sidePadding)
//                .contentShape(Rectangle())
//                .onTapGesture { onSelect(l) }
//            }
//
//            Spacer()
//
//            // RIGHT
//            if let r = right {
//                let isNeutralHead = (current == .cool && r == .neutral)
//                PeekClipText(
//                    r.label,
//                    width: isNeutralHead ? partialWidth : fullWidth,
//                    align: isNeutralHead ? .leading : .trailing
//                )
//                .padding(.trailing, sidePadding)
//                .contentShape(Rectangle())
//                .onTapGesture { onSelect(r) }
//            }
//        }
//        .frame(height: 64)
//        .padding(.top, 8)
//    }
//}
//
///// Menampilkan teks penuh lalu DI-CLIP sesuai width & alignment (tanpa “...”)
//private struct PeekClipText: View {
//    let text: String
//    let width: CGFloat
//    let align: Alignment
//
//    init(_ text: String, width: CGFloat, align: Alignment) {
//        self.text = text
//        self.width = width
//        self.align = align
//    }
//
//    var body: some View {
//        Text(text)
//            .font(.system(size: 28, weight: .bold, design: .monospaced))
//            .foregroundColor(.black.opacity(0.25))
//            .lineLimit(1)                        // satu baris
//            .fixedSize(horizontal: true, vertical: false) // biar tidak truncate
//            .minimumScaleFactor(1.0)             // jangan mengecil
//            .frame(width: width, alignment: align)
//            .clipped()                           // potong tanpa “...”
//    }
//}
import SwiftUI

struct UndertonePeekLabels: View {
    typealias U = ChooseUndertoneViewModel.Undertone
    let current: U
    var onSelect: (U) -> Void

    // HARUS match dengan header di slide
    private let titleFont = Font.system(size: 28, weight: .bold, design: .monospaced)
    private let subtitleFont = Font.system(size: 13, weight: .regular)
    private let titleSubtitleSpacing: CGFloat = 6
    private let headerHeight: CGFloat = 64     // tinggi total header (title+subtitle)
    private let headerTopPadding: CGFloat = 8  // padding atas header

    // Slot tetap (agar tidak geser)
    private let slotWidth: CGFloat = 110
    private let partialWidth: CGFloat = 64
    private let sidePadding: CGFloat = 16

    var body: some View {
        let all = U.allCases
        let idx = all.firstIndex(of: current)!
        let left: U?  = idx > 0 ? all[idx - 1] : nil
        let right: U? = idx < all.count - 1 ? all[idx + 1] : nil

        HStack(spacing: 0) {
            // LEFT slot (tetap lebarnya)
            Group {
                if let l = left {
                    let showNeutralTail = (current == .warm && l == .neutral)
                    VStack(spacing: titleSubtitleSpacing) {
                        // TITLE (peek / full)
                        HStack(spacing: 0) {
                            if showNeutralTail {
                                Spacer(minLength: 0)
                                Text(l.label)
                                    .font(titleFont)
                                    .foregroundColor(.black.opacity(0.25))
                                    .lineLimit(1)
                                    .fixedSize(horizontal: true, vertical: false)
                                    .frame(width: partialWidth, alignment: .trailing)
                                    .clipped()
                            } else {
                                Text(l.label)
                                    .font(titleFont)
                                    .foregroundColor(.black.opacity(0.25))
                                    .lineLimit(1)
                                    .frame(width: slotWidth, alignment: .leading)
                                    .clipped()
                            }
                        }
                        // GHOST SUBTITLE (kosong, hanya untuk menyamai tinggi)
                        Text(" ")
                            .font(subtitleFont)
                            .opacity(0)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(width: slotWidth, alignment: .leading)
                    .padding(.leading, sidePadding)
                    .contentShape(Rectangle())
                    .onTapGesture { onSelect(l) }
                } else {
                    Color.clear.frame(width: slotWidth)
                }
            }

            Spacer(minLength: 0)

            // RIGHT slot (tetap lebarnya)
            Group {
                if let r = right {
                    let showNeutralHead = (current == .cool && r == .neutral)
                    VStack(spacing: titleSubtitleSpacing) {
                        HStack(spacing: 0) {
                            if showNeutralHead {
                                Text(r.label)
                                    .font(titleFont)
                                    .foregroundColor(.black.opacity(0.25))
                                    .lineLimit(1)
                                    .fixedSize(horizontal: true, vertical: false)
                                    .frame(width: partialWidth, alignment: .leading)
                                    .clipped()
                                Spacer(minLength: 0)
                            } else {
                                Text(r.label)
                                    .font(titleFont)
                                    .foregroundColor(.black.opacity(0.25))
                                    .lineLimit(1)
                                    .frame(width: slotWidth, alignment: .trailing)
                                    .clipped()
                            }
                        }
                        Text(" ")
                            .font(subtitleFont)
                            .opacity(0)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(width: slotWidth, alignment: .trailing)
                    .padding(.trailing, sidePadding)
                    .contentShape(Rectangle())
                    .onTapGesture { onSelect(r) }
                } else {
                    Color.clear.frame(width: slotWidth)
                }
            }
        }
        .frame(height: headerHeight)
        .padding(.top, headerTopPadding)
        .allowsHitTesting(true)
    }
}
