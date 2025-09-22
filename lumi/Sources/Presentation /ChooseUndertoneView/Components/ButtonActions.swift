//
//  ButtonActions.swift
//  lumi
//
//  Created by Shafa Tiara Tsabita Himawan on 19/09/25.
//

import SwiftUI

struct BottomActionButtons: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var vm: ChooseUndertoneViewModel

    var body: some View {
        ZStack(alignment: .bottom) {
            ButtonBackdropGradient(plumeHeight: 170, bottomCap: 14)

            VStack(spacing: 12) {
                CustomButton(
                    title: "I DON’T KNOW MY UNDERTONE",
                    action: {
                        router.navigate(to: .undertoneQuiz)
                    },
                    isFilled: false
                )
                CustomButton(
                    title: "CONTINUE",
                    action: {
                        vm.saveUndertone()
                        router.navigate(to: .skinToneTutorial)
                    },
                    isFilled: true
                )
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }
}
