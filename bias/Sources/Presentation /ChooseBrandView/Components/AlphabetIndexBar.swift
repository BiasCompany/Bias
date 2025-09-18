import SwiftUI

private struct AlphabetIndexBar: View {
    let letters: [String]
    var onChange: (String) -> Void
    var onCommit: (() -> Void)? = nil
    // Layout
    private let hitWidth: CGFloat = 44
    private let letterSpacing: CGFloat = 2
    private let letterHeight: CGFloat = 12

    @State private var activeIndex: Int? = nil
    @State private var isTouching = false
    private let haptic = UISelectionFeedbackGenerator()

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .trailing) {
                if isTouching {
                    Capsule()
                        .fill(.ultraThinMaterial)
                        .frame(width: 28)
                        .padding(.vertical, 4)
                }

                // Letters
                VStack(spacing: letterSpacing) {
                    ForEach(letters.indices, id: \.self) { i in
                        let isActive = i == activeIndex && isTouching
                        Text(letters[i])
                            .font(.caption2)
                            .foregroundStyle(isActive ? Color.primary : Color.secondary)
                            .frame(width: 20, height: letterHeight, alignment: .center)
                            .contentShape(Rectangle())
                            .accessibilityLabel(Text("Jump to section \(letters[i])"))
                    }
                }
                .padding(.vertical, 6)
                .padding(.trailing, 2)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if !isTouching {
                            isTouching = true
                            haptic.prepare()
                        }
                        let idx = index(at: value.location, in: geo.size)
                        if idx != activeIndex, (0..<letters.count).contains(idx) {
                            activeIndex = idx
                            haptic.selectionChanged()
                            onChange(letters[idx])
                        }
                    }
                    .onEnded { _ in
                        isTouching = false
                        activeIndex = nil
                        onCommit?()
                    }
            )
        }
        .frame(width: hitWidth)
        .padding(.trailing, 6)
        .accessibilityElement(children: .contain)
    }

    private func index(at point: CGPoint, in size: CGSize) -> Int {
        let contentHeight = CGFloat(letters.count) * letterHeight + CGFloat(letters.count - 1) * letterSpacing + 12
        let top = (size.height - contentHeight) / 2.0
        let y = max(0, min(point.y - top - 6, contentHeight))
        let stride = letterHeight + letterSpacing
        let raw = Int(floor(y / stride))
        return max(0, min(raw, letters.count - 1))
    }
}