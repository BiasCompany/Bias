//
//  ResultView.swift
//  lumi
//
//  Created by Muhammad Rifqi Syatria on 9/23/25.
//


import SwiftUI
import Vision

 struct ResultView: View {
    @ObservedObject var viewModel: ResultAnalyzeViewmodel
    
    var body: some View {
        VStack(spacing: 0) {
            if let uiImage = viewModel.capturedImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
                    .overlay(
                        GeometryReader { geo in
                            ForEach(viewModel.detectionPoints) { point in
                                let x = geo.size.width * point.position.x
                                let y = geo.size.height * (1 - point.position.y)
                                
                                if point.isDebug {
//                                    Circle()
//                                        .fill(Color.red)
//                                        .frame(width: 5, height: 5)
//                                        .position(x: x, y: y)
                                } else {
                                    VStack(spacing: 2) {
                                        Circle()
                                            .fill(point.color)
                                            .frame(width: 20, height: 20)
                                            .overlay(Circle().stroke(.white, lineWidth: 2))
                                        if let label = point.label {
                                            Text(label)
                                                .font(.caption2)
                                                .foregroundColor(.white)
                                                .shadow(radius: 2)
                                        }
                                    }
                                    .position(x: x, y: y)
                                    .onTapGesture {
                                        viewModel.selectDetectionPoint(point.id)
                                    }
                                }
                            }
                        }
                    )
            } else {
                Image("syatria")
                    .resizable()
                    .scaledToFill()
                    .aspectRatio(3 / 4, contentMode: .fit)
                    .clipped()
            }
            
            Spacer()
            
            SkinTonePanel(
                toneText: "\(classifySkinTone(hex: "\(viewModel.currentSkinToneText)"))",
                background: viewModel.panelBackgroundColor,
                onFindShade: {
                    viewModel.findMyShade()
                }
            )
        }
    }
}
