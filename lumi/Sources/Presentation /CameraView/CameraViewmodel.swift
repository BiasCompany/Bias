//
//  CameraViewmodel.swift
//  lumi
//
//  Created by Shafa Tiara Tsabita Himawan on 20/09/25.
//

import AVFoundation
import AudioToolbox
import Combine
import Foundation
import SwiftUI

final class CameraViewmodel: ObservableObject {

    @Published var faceDetected: Bool = false
    @Published var lightAdequate: Bool = false
    @Published var accessoriesDetected: Bool = false
    @Published var capturedImage: UIImage?
    @Published var showResultView: Bool = false
    @Published var isCapturing: Bool = false
    @Published var isHolding: Bool = false
    @Published var cameraSessionRunning: Bool = false
    @Published var cameraPermissionDenied: Bool = false
    @Published var accessoryStatus: AccessoryStatus = .unknown
    @Published var previewLayer: AVCaptureVideoPreviewLayer?

    private let service: FaceDetectionService
    private weak var router: Router?
    private weak var resultVM: ResultAnalyzeViewmodel?
    private var pollTimer: Timer?
    private var captureTimer: Timer?
    private var holdTimer: Timer?
    private let pollInterval: TimeInterval = 0.25
    private let captureDuration: TimeInterval = 3.0

    private(set) var lastAnalysis: FaceAnalysis?

    init(service: FaceDetectionService = FaceDetectionService(), router: Router? = nil, resultVM: ResultAnalyzeViewmodel? = nil) {
        self.service = service
        self.router = router
        self.resultVM = resultVM
    }

    func startCameraSession() {
        // Reset any previous state
        resetCameraState()
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            startSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if granted { self.startSession() }
                    else {
                        self.cameraSessionRunning = false
                        self.cameraPermissionDenied = true
                        self.resetCaptureState()
                    }
                }
            }
        default:
            cameraSessionRunning = false
            cameraPermissionDenied = true
            resetCaptureState()
        }
    }

    private func startSession() {
        do {
            try service.start()
            if previewLayer == nil {
                let layer = AVCaptureVideoPreviewLayer(session: service.captureSession)
                layer.videoGravity = .resizeAspectFill
                layer.connection?.videoOrientation = .portrait
                self.previewLayer = layer
            } else {
                previewLayer?.connection?.videoOrientation = .portrait
            }
            cameraSessionRunning = true
            startPolling()
        } catch {
            print("Camera start error: \(error)")
            cameraSessionRunning = false
        }
    }

    func stopCameraSession() {
        stopPolling()
        service.stop()
        cameraSessionRunning = false
    }
    
    private func resetCameraState() {
        // Reset all camera-related state
        faceDetected = false
        lightAdequate = false
        accessoriesDetected = false
        capturedImage = nil
        showResultView = false
        isCapturing = false
        isHolding = false
        cameraSessionRunning = false
        cameraPermissionDenied = false
        accessoryStatus = .unknown
        lastAnalysis = nil
        
        // Reset timers
        resetCaptureState()
        
        // Reset the service
        service.reset()
    }

    private func startPolling() {
        stopPolling()
        pollTimer = Timer.scheduledTimer(withTimeInterval: pollInterval, repeats: true) { [weak self] _ in
            self?.updateDetectionStatus()
        }
        RunLoop.main.add(pollTimer!, forMode: .common)
    }

    private func stopPolling() {
        pollTimer?.invalidate()
        pollTimer = nil
    }

    private func updateDetectionStatus() {
        let light = service.checkLight()
        lightAdequate = (light == .good)

        let vis = service.checkFaceVisibility()
        faceDetected = vis.visible
        lastAnalysis = vis.analysis

        if faceDetected {
            accessoryStatus = service.checkAccessoriesExist()
        } else {
            accessoryStatus = .unknown
        }
        accessoriesDetected = (accessoryStatus != .none)

        let allGood = faceDetected && lightAdequate && !accessoriesDetected
        if !allGood {
            cancelHold()
        }
    }


    func considerStartFlow() {
        if showResultView { return }
        let allGood = faceDetected && lightAdequate && !accessoriesDetected
        if allGood {
            if !isHolding && !isCapturing { startHold() }
        } else {
            cancelHold()
            cancelCapture()
        }
    }

    private func startHold() {
        isHolding = true
        holdTimer?.invalidate()
        holdTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            let allGood = self.faceDetected && self.lightAdequate && !self.accessoriesDetected
            if allGood {
                self.startCountdown()
            } else {
                self.isHolding = false
            }
        }
        if let holdTimer { RunLoop.main.add(holdTimer, forMode: .common) }
    }

    private func startCountdown() {
        isHolding = false
        isCapturing = true
        print("[Camera] Countdown started (")
        captureTimer?.invalidate()
        captureTimer = Timer.scheduledTimer(withTimeInterval: captureDuration, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            print("[Camera] Countdown finished → capturing photo...")
            Task { await self.performPhotoCapture() }
        }
        if let captureTimer { RunLoop.main.add(captureTimer, forMode: .common) }
    }
    @MainActor
    private func performPhotoCapture() async {
        defer { resetCaptureState() }
        do {
            print("[Camera] captureImage() begin")
            let raw = try await service.captureImage()

            // Jika orientation mengandung mirror, unmirror. Sekalian normalize orientation.
            let shouldUnmirror = raw.isMirroredOrientation
            let normalized = raw.fixedOrientation()
            let finalImage = shouldUnmirror ? normalized.unmirroredHorizontally() : normalized

            self.capturedImage = finalImage
            playCaptureFeedback()
            self.showResultView = true
            print("[Camera] captureImage() success → showResultView = true")
        } catch {
            print("Photo capture error: \(error.localizedDescription)")
            self.capturedImage = nil
            self.showResultView = false
        }
    }


    private func playCaptureFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.success)
        AudioServicesPlaySystemSound(1108)
    }

    func retakePhoto() {
        capturedImage = nil
        showResultView = false
        resetCaptureState()
//        startCameraSession()
    }

    @MainActor
    func startAnalysis() {
        guard let image = capturedImage
        else {
            print("[Camera] startAnalysis called without image")
            return
        }
        print("[Camera] startAnalysis: handoff image to ResultAnalyzeViewmodel")
        showResultView = false
        stopCameraSession()
        router?.navigate(to: .skinToneResult(image: image))
    }

    private func resetCaptureState() {
        isCapturing = false
        isHolding = false
        captureTimer?.invalidate()
        captureTimer = nil
        holdTimer?.invalidate()
        holdTimer = nil
    }

    private func cancelHold() {
        if isHolding {
            isHolding = false
            holdTimer?.invalidate()
            holdTimer = nil
        }
    }

    private func cancelCapture() {
        if isCapturing {
            isCapturing = false
            captureTimer?.invalidate()
            captureTimer = nil
        }
    }
}

private extension UIImage {
    var isMirroredOrientation: Bool {
        switch imageOrientation {
        case .upMirrored, .downMirrored, .leftMirrored, .rightMirrored:
            return true
        default:
            return false
        }
    }

    func fixedOrientation() -> UIImage {
        if imageOrientation == .up { return self }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let normalized = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        return normalized
    }

    func unmirroredHorizontally() -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = self.scale
        let renderer = UIGraphicsImageRenderer(size: self.size, format: format)
        return renderer.image { ctx in
            let cg = ctx.cgContext
            cg.translateBy(x: self.size.width, y: 0)
            cg.scaleBy(x: -1, y: 1)
            self.draw(in: CGRect(origin: .zero, size: self.size))
        }
    }
}

