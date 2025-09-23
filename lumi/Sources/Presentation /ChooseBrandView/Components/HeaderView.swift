import SwiftUI

struct HeaderView: View {
    @Binding var searchText: String
    var isFocused: FocusState<Bool>.Binding
    var onCancel: () -> Void = {}
    var onToggleAll: (() -> Void)? = nil
    var isAllSelected: Bool = false

    private let side: CGFloat = 16
    var showCancel: Bool { isFocused.wrappedValue || !searchText.isEmpty }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                Text("BRAND TO MATCH")
                    .font(.title2.monospaced().bold())
                    .kerning(-0.5)
                    .foregroundStyle(.primary)
                    .padding(.top, 8)

                Spacer()

                Button(isAllSelected ? "Clear" : "Select all") {
                    onToggleAll?()
                }
                .buttonStyle(.plain)
                .font(.caption)
                .foregroundStyle(.black)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("What is your brand preference?")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Text("You can select one or more brand.")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            SearchView(
                searchText: $searchText, isFocused: isFocused, onCancel: onCancel
            )
        }
        .padding(.horizontal, side)
        .padding(.bottom, 10)
    }
}

#Preview {
    struct PreviewContainer: View {
        @State var searchText = "Searxhj"
        @FocusState var isFocused: Bool
        var body: some View {
            HeaderView(
                searchText: $searchText,
                isFocused: $isFocused,
                onCancel: {},
                onToggleAll: {},
                isAllSelected: true
            )
        }
    }
    return PreviewContainer()
}
