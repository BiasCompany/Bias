//
//  CameraViewmodel.swift
//  bias
//
//  Created by Shafa Tiara Tsabita Himawan on 20/09/25.
//

import Foundation
import SwiftUI
import AVFoundation
import Combine

final class CameraViewmodel: NSObject, ObservableObject {
    
    @Published var faceDetected: Bool = false
    @Published var lightAdequate: Bool = false
    @Published var accessoriesDetected: Bool = false
    @Published var capturedImage: UIImage?
    @Published var showResultView: Bool = false
    @Published var isCapturing: Bool = false
    @Published var cameraSessionRunning: Bool = false
    @Published var previewLayer: AVCaptureVideoPreviewLayer?
    
    private let captureSession = AVCaptureSession()
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private let photoOutput = AVCapturePhotoOutput()
    private let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutputQueue")
    private var cancellables = Set<AnyCancellable>()
    private var captureTimer: Timer?
    private let captureDuration: TimeInterval = 3.0
    
    override init() {
        super.init()
        setupCameraSession()
    }
    
    private func setupCameraSession() {
        captureSession.sessionPreset = .photo
        
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            print("Failed to get front camera")
            return
        }
        
        do {
            let cameraInput = try AVCaptureDeviceInput(device: camera)
            
            captureSession.beginConfiguration()
            
            if captureSession.canAddInput(cameraInput) {
                captureSession.addInput(cameraInput)
            }
            
            if captureSession.canAddOutput(videoDataOutput) {
                captureSession.addOutput(videoDataOutput)
                videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
            }
            
            if captureSession.canAddOutput(photoOutput) {
                captureSession.addOutput(photoOutput)
            }
            
            captureSession.commitConfiguration()
            
            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = .resizeAspectFill
            self.previewLayer = previewLayer
            
        } catch {
            print("Error setting up camera: \(error)")
        }
    }
    
    func startCameraSession() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            if !self.captureSession.isRunning {
                self.captureSession.startRunning()
                DispatchQueue.main.async {
                    self.cameraSessionRunning = true
                }
            }
        }
    }
    
    func stopCameraSession() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            if self.captureSession.isRunning {
                self.captureSession.stopRunning()
                DispatchQueue.main.async {
                    self.cameraSessionRunning = false
                }
            }
        }
    }
    
    func updateDetectionStatus() {
        // TODO: Implement real face detection, lighting, and accessories detection
        faceDetected = true
        lightAdequate = true
        accessoriesDetected = false
    }
    
    func triggerCapture() {
        guard !isCapturing, faceDetected, lightAdequate, !accessoriesDetected else { return }
        
        isCapturing = true
        
        captureTimer = Timer.scheduledTimer(withTimeInterval: captureDuration, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            self.performPhotoCapture()
        }
        RunLoop.main.add(captureTimer!, forMode: .common)
    }
    
    private func performPhotoCapture() {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func retakePhoto() {
        capturedImage = nil
        showResultView = false
        resetCaptureState()
    }
    
    func startAnalysis() {
        // TODO: Implement navigation to skin analysis result
        print("Starting analysis with captured image.")
    }
    
    private func resetCaptureState() {
        isCapturing = false
        captureTimer?.invalidate()
        captureTimer = nil
    }
}

extension CameraViewmodel: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // TODO: Implement real detection logic here
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if !self.isCapturing && !self.showResultView {
                self.updateDetectionStatus()
            }
        }
    }
}

extension CameraViewmodel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.isCapturing = false
            
            if let error = error {
                print("Photo capture error: \(error.localizedDescription)")
                self.capturedImage = nil
                self.showResultView = false
                self.resetCaptureState()
            } else if let imageData = photo.fileDataRepresentation(),
                      let image = UIImage(data: imageData) {
                self.capturedImage = image
                self.showResultView = true
            } else {
                print("Failed to create image from photo data")
                self.capturedImage = nil
                self.showResultView = false
                self.resetCaptureState()
            }
        }
    }
}
