import SwiftUI

struct ChooseUndertoneView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var vm: ChooseUndertoneViewModel

    private var selectedBinding: Binding<ChooseUndertoneViewModel.Undertone> {
        Binding(
            get: { vm.selected },
            set: { vm.select($0) }
        )
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Nav
                HStack {
                    Button(action: { router.navigateBack() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(width: 44, height: 44)
                            .contentShape(Rectangle())
                            .accessibilityLabel("Back")
                    }
                    .buttonStyle(.plain)

                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)

                // Title
                VStack(alignment: .leading, spacing: 4) {
                    Text("WHAT IS YOUR")
                    Text("UNDERTONE?")
                }
                .font(Font.title2.bold().monospaced())
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.top, 8)

                // Info card
                InfoBanner(text: vm.infoText)
                    .padding(.horizontal, 16)
                    .padding(.top, 10)
                UndertoneCarousel(selected: selectedBinding)
            }
            BottomActionButtons(
                onIDK: { router.navigate(to: .undertoneQuiz) },
                onContinue: { }
            )
        }
        .animation(.easeInOut, value: vm.selected)
        .navigationBarBackButtonHidden()
        .toolbar(.hidden)
    }
}

#Preview { ChooseUndertoneView() }
