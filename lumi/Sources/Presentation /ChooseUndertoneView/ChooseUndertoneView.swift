import SwiftUI

struct ChooseUndertoneView: View {
    var isEdit: Bool = false
    @EnvironmentObject var router: Router
    @EnvironmentObject var vm: ChooseUndertoneViewModel

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Nav
                BackButton()
                .padding(.horizontal, 4)
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
                InfoBanner()
                    .padding(.horizontal, 16)
                    .padding(.top, 10)
                UndertoneCarousel()
            }
            BottomActionButtons(isEdit: isEdit)
        }
        .animation(.easeInOut, value: vm.selected)
        .navigationBarBackButtonHidden()
        .toolbar(.hidden)
    }
}

#Preview {
    let vm = ChooseUndertoneViewModel()
    ChooseUndertoneView().environmentObject(vm) }
