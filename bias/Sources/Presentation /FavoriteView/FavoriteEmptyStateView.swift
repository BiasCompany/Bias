import SwiftUI

struct FavoriteEmptyStateView: View {
    var title: String = "NO FAVORITES YET"
    var message: String = "Your favorite foundation will be listed here,\nto save start tap the heart icon."

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "heart.fill")
                .font(.system(size: 44))
                .foregroundStyle(.tertiary)
                .symbolRenderingMode(.palette)

            Text(title.uppercased())
                .font(.system(.title2, design: .monospaced))
                .fontWeight(.semibold)
                .tracking(1)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

            Text(message)
                .font(.callout)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .fontWeight(.regular)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 24)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text("No favorites yet. \(message)"))
    }
}

#Preview("Light") {
    FavoriteEmptyStateView()
}

