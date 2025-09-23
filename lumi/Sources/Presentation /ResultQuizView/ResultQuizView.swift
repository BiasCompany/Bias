//
//  ResultQuizView 2.swift
//  lumi
//
//  Created by Muhammad Rifqi Syatria on 9/19/25.
//

import SwiftUI

struct ResultQuizView: View {
    var isEdit: Bool = false
    @EnvironmentObject private var router: Router
    @EnvironmentObject var viewModel: QuizUndertoneViewModel

    var body: some View {
        VStack(spacing: 24) {
            BackButton(
                onTap: {
                    viewModel.resetState()
                    router.navigateBack()
                }
            )

            Spacer()
            Text("Your Undertone Result".uppercased())
                .font(.system(.title3, design: .monospaced).weight(.semibold))
            Text(viewModel.result.rawValue.uppercased())
                .font(.system(.title, design: .monospaced).weight(.bold))
                .foregroundColor(.black)
            if let description = viewModel.undertoneDescription {
                Text(description)
                    .font(.caption)
                    .fontWeight(.regular)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 270)
            }
            Spacer()
            ZStack {
                Image("hands")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: .infinity)

                if let imageName = viewModel.undertoneImage {
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(12)
                }

                VStack {
                    Spacer()
                    WhiteGradientView()
                }
            }

            CustomButton(
                title: "Continue",
                action: {
                    viewModel.saveUndertone()
                }, isFilled: true)
        }
        .padding()
        .navigationBarBackButtonHidden()
        .onChange(of: viewModel.isLoading) { prev, current in
            if !current {
                if isEdit {
                    router.replaceNavigationPath(with: [.recommendation, .skinAnalysis])
                } else {
                    router.navigate(to: .skinToneTutorial)
                }
                viewModel.resetState()
            }
        }
    }
}

//
//#Preview {
//    let vm = ChooseUndertoneViewModel()
//    vm.answers = ["Purple", "My skin looks pinkish or bluish", "Silver", "Pure White flatters me more"]
//    vm.nextStep()
//    vm.nextStep()
//    vm.nextStep()
//    vm.nextStep()
//    return ResultQuizView(viewModel: vm)
//}
//
