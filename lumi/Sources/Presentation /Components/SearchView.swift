import SwiftUI

struct SearchView: View {
    @Binding var searchText: String
    var isFocused: FocusState<Bool>.Binding
    var onCancel: () -> Void = {}

    private let side: CGFloat = 16
    var showCancel: Bool { isFocused.wrappedValue || !searchText.isEmpty }
    
    var body: some View {
        
            HStack(spacing: 8) {
                ZStack {
                    Rectangle()
                        .stroke(.black, lineWidth: 1)
                        .frame(height: 36)
                        .background(Color(.white))

                    HStack(spacing: 10) {
                        Image(systemName: "magnifyingglass")
                        TextField("Search brand...", text: $searchText)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                            .font(.caption)
                            .focused(isFocused)

                        if !searchText.isEmpty {
                            Button {
                                searchText = ""
                            } label: {
                                Image(systemName: "xmark.circle")
                                    .font(.body)
                                    .foregroundStyle(.primary)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 12)
                }
                .frame(maxWidth: .infinity)
                if showCancel {
                    Button("Cancel") {
                        onCancel()
                    }
                    .buttonStyle(.plain)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .transition(.opacity.combined(with: .move(edge: .trailing)))
                }
            }
            .animation(.easeInOut(duration: 0.15), value: showCancel)
    }
}

#Preview {
    struct PreviewContainer: View {
        @State var searchText = "Searxhj"
        @FocusState var isFocused: Bool
        var body: some View {
            SearchView(
                searchText: $searchText,
                isFocused: $isFocused,
                onCancel: {}
            )
        }
    }
    return PreviewContainer()
}
