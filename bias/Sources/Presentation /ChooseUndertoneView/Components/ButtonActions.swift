//
//  ButtonActions.swift
//  bias
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
<<<<<<< HEAD
                    action:  {
                        router.navigate(to: .undertoneQuiz)
                    },
                    isFilled: false
=======
                    action: onIDK, isFilled: false
>>>>>>> 91b7919 (feat: adding empty state favorite)
                )
                CustomButton(
                    title: "CONTINUE",
<<<<<<< HEAD
                    action: {
                        vm.saveUndertone()
                        router.navigate(to: .skinToneTutorial)
                    }
                    ,
                    isFilled: true
=======
                    action: onContinue, isFilled: true
>>>>>>> 91b7919 (feat: adding empty state favorite)
                )
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }
}
