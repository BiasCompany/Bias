import SwiftUI

struct UndertonePeekLabels: View {
    @EnvironmentObject var vm: ChooseUndertoneViewModel

    // HARUS match dengan header di slide
    private let titleFont = Font.system(size: 28, weight: .bold, design: .monospaced)
    private let subtitleFont = Font.system(size: 13, weight: .regular)
    private let titleSubtitleSpacing: CGFloat = 6
    private let headerHeight: CGFloat = 64  // tinggi total header (title+subtitle)
    private let headerTopPadding: CGFloat = 8  // padding atas header

    // Slot tetap (agar tidak geser)
    private let slotWidth: CGFloat = 60
    private let partialWidth: CGFloat = 64
    private let sidePadding: CGFloat = 16

    var body: some View {
        let all = [Undertone.warm, Undertone.neutral, Undertone.cool]
        let idx = all.firstIndex(of: vm.selected)!
        let left: Undertone? = idx > 0 ? all[idx - 1] : nil
        let right: Undertone? = idx < all.count - 1 ? all[idx + 1] : nil

        HStack(spacing: 0) {
            // LEFT slot (tetap lebarnya)
            Group {
                if let l = left {
                    ZStack {
                        VStack(spacing: titleSubtitleSpacing) {
                            Text(getTitle(undertone: l))
                                .font(titleFont)
                                .foregroundColor(.black.opacity(0.25))
                                .lineLimit(1)
                                .fixedSize(horizontal: true, vertical: false)
                                .frame(width: slotWidth, alignment: .trailing)
                                .clipped()
                            Text(" ")
                                .font(subtitleFont)
                                .opacity(0)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        LinearGradient(
                            gradient: Gradient(colors: [.white, .white.opacity(0)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .allowsHitTesting(false)
                    }
                    .frame(width: slotWidth, alignment: .trailing)
                    .padding(.leading, sidePadding)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.easeInOut) { vm.select(l) }
                    }
                } else {
                    Color.clear.frame(width: slotWidth)
                }
            }

            Spacer(minLength: 0)

            // RIGHT slot (tetap lebarnya)
            Group {
                if let r = right {
                    ZStack {
                        VStack(spacing: titleSubtitleSpacing) {
                            Text(getTitle(undertone: r))
                                .font(titleFont)
                                .foregroundColor(.black.opacity(0.25))
                                .lineLimit(1)
                                .fixedSize(horizontal: true, vertical: false)
                                .frame(width: slotWidth, alignment: .leading)
                                .clipped()
                            Text(" ")
                                .font(subtitleFont)
                                .opacity(0)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        LinearGradient(
                            gradient: Gradient(colors: [.white.opacity(0), .white]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .allowsHitTesting(false)
                    }
                    .frame(width: slotWidth, alignment: .leading)
                    .padding(.trailing, sidePadding)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.easeInOut) { vm.select(r) }
                    }
                } else {
                    Color.clear.frame(width: slotWidth)
                }
            }
        }
        .frame(height: headerHeight)
        .padding(.top, headerTopPadding)
        .allowsHitTesting(true)
    }

    func getTitle(undertone: Undertone) -> String {
        switch undertone {
        case .cool: return "COOL"
        case .neutral: return "NEUTRAL"
        case .warm: return "WARM"
        case .unknown: return "UNKNOWN"
        }
    }

}

#Preview {
    UndertonePeekLabels()
        .environmentObject(ChooseUndertoneViewModel())
}
