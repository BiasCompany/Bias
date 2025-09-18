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
        .padding(.horizontal, side)
        .padding(.bottom, 10)
    }
}
