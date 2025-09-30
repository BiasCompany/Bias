//
//  CameraView.swift
//  lumi
//
//  Created by Shafa Tiara Tsabita Himawan on 20/09/25.
//

import AVFoundation
import SwiftUI

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
    
    private var accessoriesOK: Bool {
        viewModel.faceDetected && !viewModel.accessoriesDetected
    }
    
    var body: some View {
        ZStack {
            if viewModel.cameraPermissionDenied {
                UnableAccessCamera(onBack: { dismiss() })
            } else if viewModel.cameraSessionRunning {
                CameraPreview(viewModel: viewModel)
                    .ignoresSafeArea()
            } else {
                Color.black.ignoresSafeArea()
                Text("Camera Not Running").foregroundColor(.white)
            }

            if !viewModel.cameraPermissionDenied {
                CameraOverlay()
                    .ignoresSafeArea()
            }

            if !viewModel.cameraPermissionDenied {
                VStack {
                    Spacer()
                    if !viewModel.showResultView {
                        CaptureStatusWithGuidance(
                            face: viewModel.faceDetected ? .good : .bad,
                            light: viewModel.lightAdequate ? .good : .bad,
                            accessories: accessoriesOK ? .good : .bad
                        )
                        .padding(.bottom, 30)
                    }
                }
            }
            
            if !viewModel.cameraPermissionDenied && viewModel.isCapturing && !viewModel.showResultView {
                CaptureView()
                    .frame(width: 330, height: 330)
                    .position(x: UIScreen.main.bounds.width / 2,
                              y: UIScreen.main.bounds.height / 2)
                    .offset(y: -(UIScreen.main.bounds.height * 0.20))
                    .zIndex(2)
            }

            if !viewModel.cameraPermissionDenied && viewModel.isHolding && !viewModel.showResultView {
                VStack {
                    Spacer()
                    Text("HOLD STILL")
                        .font(.system(.title3, design: .monospaced, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.bottom, 250)
                }
                .zIndex(2)
            }
            if !viewModel.cameraPermissionDenied && viewModel.showResultView, let image = viewModel.capturedImage {
                PhotoResult(
                    image: image,
                    onRetake: { viewModel.retakePhoto() },
                    onStartAnalysis: { viewModel.startAnalysis() }
                )
                .ignoresSafeArea() 
                .overlay(alignment: .bottom) {
                    ButtonRetake(
                        onRetake: { viewModel.retakePhoto() },
                        onStartAnalysis: { viewModel.startAnalysis() }
                    )
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.bottom, 12)
                }
                .transition(.opacity)
                .zIndex(3)
            }

        }
        .overlay(alignment: .topTrailing) {
            if !viewModel.cameraPermissionDenied && !viewModel.showResultView {
                ButtonX(onClose: { dismiss() })
                    .padding(.trailing, 16)
                    .padding(.top, 10)
                    .zIndex(10)
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear { viewModel.startCameraSession() }
        .onDisappear { viewModel.stopCameraSession() }
        .onChange(of: viewModel.faceDetected) { _, _ in viewModel.considerStartFlow() }
        .onChange(of: viewModel.lightAdequate) { _, _ in viewModel.considerStartFlow() }
        .onChange(of: viewModel.accessoriesDetected) { _, _ in viewModel.considerStartFlow() }
    }

}
