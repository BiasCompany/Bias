//
//  PhotoResult.swift
//  lumi
//
//  Created by Shafa Tiara Tsabita Himawan on 19/09/25.
//

import SwiftUI

struct PhotoResult: View {
    let image: UIImage
    var onRetake: () -> Void
    var onStartAnalysis: () -> Void

    init(
        image: UIImage,
        onRetake: @escaping () -> Void,
        onStartAnalysis: @escaping () -> Void
    ) {
        self.image = image
        self.onRetake = onRetake
        self.onStartAnalysis = onStartAnalysis
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(
                        width: geo.size.width,
                        height: geo.size.height + geo.safeAreaInsets.top + geo.safeAreaInsets.bottom
                    )
                    .clipped()
                    .ignoresSafeArea()

                LinearGradient(
                    stops: [
                        .init(color: .black, location: 0.00),
                        .init(color: Color(white: 0.85).opacity(0), location: 1.00),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: geo.size.height * 0.28)
                .allowsHitTesting(false)
                .ignoresSafeArea(edges: .top)

                Text("YOUR  PHOTO  RESULT")
                    .font(.system(size: 20, weight: .heavy, design: .monospaced))
                    .kerning(1)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 8)
                    .padding(.top, geo.safeAreaInsets.top + geo.size.height * 0.1)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

#Preview {
    PhotoResult(
        image: UIImage(named: "cameraPreviewMock") ?? UIImage(),
        onRetake: {},
        onStartAnalysis: {}
    )
}
