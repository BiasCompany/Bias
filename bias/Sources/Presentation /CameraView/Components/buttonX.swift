//
//  buttonX.swift
//  bias
//
//  Created by Shafa Tiara Tsabita Himawan on 20/09/25.
//

import SwiftUI

public struct ButtonX: View {
    public var onClose: (() -> Void)?
    
    public init(onClose: (() -> Void)? = nil) {
        self.onClose = onClose
    }
    
    public var body: some View {
        Button(action: { onClose?() }) {
            Circle()
                .fill(Color.white)
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: "xmark")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.black)

                )
            
            
        }
        .accessibilityLabel("Close Camera")
    }
}

#Preview {
    ZStack {
        Color.blue.ignoresSafeArea()
        ButtonX {
            print("Close tapped")
        }
        .padding(.trailing, 20)
        .padding(.top, 20)
    }
}
