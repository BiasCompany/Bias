//
//  CameraView.swift
//  bias
//
//  Created by Shafa Tiara Tsabita Himawan on 20/09/25.
//

import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
    @ObservedObject var viewModel: CameraViewmodel

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        if let previewLayer = viewModel.previewLayer {
            previewLayer.frame = view.bounds
            view.layer.addSublayer(previewLayer)
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        if let previewLayer = viewModel.previewLayer {
            previewLayer.frame = uiView.bounds
            if uiView.layer.sublayers?.contains(previewLayer) == false {
                uiView.layer.addSublayer(previewLayer)
            }
        }
    }
}

struct CameraView: View {
    @EnvironmentObject var viewModel: CameraViewmodel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            if viewModel.cameraSessionRunning {
                CameraPreview(viewModel: viewModel)
                    .ignoresSafeArea()
            } else {
                Color.black.ignoresSafeArea()
                Text("Camera Not Running")
                    .foregroundColor(.white)
            }
            
            CameraOverlay()
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Spacer()
                    if !viewModel.showResultView {
                        ButtonX {
                            dismiss()
                        }
                        .padding(.trailing, 20)
                    }
                }
                .padding(.top, 10)
                
                Spacer()
                
                if !viewModel.showResultView {
                    CaptureStatusWithGuidance(
                        face: viewModel.faceDetected ? .good : .bad,
                        light: viewModel.lightAdequate ? .good : .bad,
                        accessories: viewModel.accessoriesDetected ? .bad : .good
                    )
                    .padding(.bottom, 30)
                }
            }
            
            if viewModel.isCapturing && !viewModel.showResultView {
                CaptureView {
                    
                }
                .frame(width: 330, height: 330)
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
            }
            
            if viewModel.showResultView, let image = viewModel.capturedImage {
                VStack {
                    Spacer()
                    
                    Text("YOUR PHOTO RESULT")
                        .font(.system(size: 20, weight: .semibold, design: .monospaced))
                        .foregroundColor(.white)
                        .padding(.bottom, 20)
                    
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.8)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.bottom, 30)
                    
                    ButtonRetake(
                        onRetake: {
                            viewModel.retakePhoto()
                        },
                        onStartAnalysis: {
                            viewModel.startAnalysis()
                        }
                    )
                }
                .ignoresSafeArea()
                .background(Color.black.opacity(0.9))
                .transition(.opacity)
            }
        }
        .onAppear {
            viewModel.startCameraSession()
        }
        .onDisappear {
            viewModel.stopCameraSession()
        }
        .onChange(of: viewModel.faceDetected) { _, _ in
            checkReadyForCapture()
        }
        .onChange(of: viewModel.lightAdequate) { _, _ in
            checkReadyForCapture()
        }
        .onChange(of: viewModel.accessoriesDetected) { _, _ in
            checkReadyForCapture()
        }
    }
    
    private func checkReadyForCapture() {
        if !viewModel.isCapturing && 
           !viewModel.showResultView && 
           viewModel.faceDetected && 
           viewModel.lightAdequate && 
           !viewModel.accessoriesDetected {
            viewModel.triggerCapture()
        }
    }
}

//struct CameraView_Previews: PreviewProvider {
//    static var previews: some View {
//        CameraView()
//    }
//}
