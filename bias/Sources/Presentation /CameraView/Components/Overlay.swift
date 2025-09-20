//
//  Overlay.swift
//  bias
//
//  Created by Shafa Tiara Tsabita Himawan on 19/09/25.
//

import SwiftUI

public struct CameraOverlay: View {
    public var onClose: (() -> Void)?

    public init(onClose: (() -> Void)? = nil) {
        self.onClose = onClose
    }

    public var body: some View {
        ZStack {
            Image("dotOverlay")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .ignoresSafeArea()
                
            Image("blackOverlay")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .ignoresSafeArea()
                .opacity(0.5)
                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                .blur(radius: 3.85)
        }
    }
}

#Preview {
    ZStack {
        Color.blue.ignoresSafeArea()
        Image("cameraPreviewMock")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()

        CameraOverlay {
            print("Close tapped")
        }
    }
}
