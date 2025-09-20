//
//  PhotoResult.swift
//  bias
//
//  Created by Shafa Tiara Tsabita Himawan on 19/09/25.
//

import SwiftUI

struct PhotoResult: View {
    let image: UIImage
    var onRetake: () -> Void
    var onStartAnalysis: () -> Void

    init(image: UIImage,
         onRetake: @escaping () -> Void,
         onStartAnalysis: @escaping () -> Void) {
        self.image = image
        self.onRetake = onRetake
        self.onStartAnalysis = onStartAnalysis
    }

    var body: some View {
        ZStack {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
        .safeAreaInset(edge: .top) {
            Text("YOUR  PHOTO  RESULT")
                .font(.system(size: 20, weight: .heavy, design: .monospaced))
                .kerning(1)
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.6), radius: 4, x: 0, y: 2)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 8)
                .background(Color.clear)
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
