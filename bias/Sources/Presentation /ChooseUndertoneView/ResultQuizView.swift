//
//  ResultQuizView 2.swift
//  bias
//
//  Created by Muhammad Rifqi Syatria on 9/19/25.
//


import SwiftUI

struct ResultQuizView: View {
    @StateObject var viewModel: ChooseUndertoneViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            
            Spacer()
            Text("Your Undertone Result")
                .font(.system(.title3, design: .monospaced).weight(.semibold))
            Text(viewModel.result)
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
            
            
            CustomButton(title: "Continue", isFilled: true, action: {
                print("Continue tapped")
            })
        }
        .padding()
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

