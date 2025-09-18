//
//  CustomButton.swift
//  bias
//
//  Created by Muhammad Rifqi Syatria on 9/18/25.
//

import SwiftUI

enum ButtonVariant {
    case active
    case disabled
    
}


struct CustomButton: View {
    let title: String
    let isFilled: Bool
    let action: () -> Void
    var isIconOnly: Bool = false
    var variant: ButtonVariant = .active
    private var backgroundColor : Color {
        switch variant {
            case .active:
            return .black
        case .disabled:
            return .gray
        }
    }

    var body: some View {
        Button(action: action) {
            Group {
                if isIconOnly {
                    Image(systemName: title)
                } else {
                    Text(title)
                }
            }
            .font(.system(size: 16, weight: .medium, design: .monospaced))
            .frame(maxWidth: .infinity, minHeight: 48)
            .background(isFilled ? backgroundColor : Color.white )
            .foregroundColor(isFilled ? .white : .black)
            .overlay(
                Rectangle()
                    .stroke(Color.black, lineWidth: isFilled ? 0 : 1)
            )
        }.disabled(variant == .disabled)
        
    }
}

#Preview {
    VStack(spacing: 16) {
        CustomButton(title: "CONTINUE", isFilled: true, action: {})
        CustomButton(title: "I DON’T KNOW MY UNDERTONE", isFilled: false, action: {})
        CustomButton(title: "star", isFilled: false, action: {}, isIconOnly: true)
        CustomButton(title: "next", isFilled: true, action: {}, isIconOnly: false, variant: .disabled)
    }
    .padding()
}
