//
//  PhotoResultView.swift
//  lumi
//
//  Created by Muhammad Rifqi Syatria on 9/23/25.
//


import SwiftUI
import Vision

struct PhotoResultView: View {
    @ObservedObject var viewModel: ResultAnalyzeViewmodel
    
    var body: some View {
        ZStack(){
            GeometryReader { geo in
                if let uiImage = viewModel.capturedImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                    
                    
                        .overlay(
                            GeometryReader { geo in
                                ForEach(viewModel.detectionPoints) { point in
                                    let x = geo.size.width * point.position.x
                                    let y = geo.size.height * (1 - point.position.y)
                                    
                                    if point.isDebug {
                                        
//                                        Circle()
//                                            .fill(Color.red)
//                                            .frame(width: 5, height: 5)
//                                            .position(x: x, y: y)
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
                    
                    
                }
            }
            VStack() {
                
                Spacer()
                Spacer()
                Spacer()
                
                
                Text(viewModel.instructionText)
                    .frame(maxWidth: .infinity)
                    .font(.system(.callout, design: .monospaced))
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .padding(.top, 24)
                    .background{
                        BlackGradientView()
                            .frame(height:200 )
                            .ignoresSafeArea(edges: .bottom)
                    }
                
                Spacer()
            }
        }
        .ignoresSafeArea(.all)
    }
}
