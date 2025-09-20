//
//  FaceDetectionService.swift
//  bias
//
//  Created by Shafa Tiara Tsabita Himawan on 20/09/25.
//

import Foundation
import UIKit
import AVFoundation
import Vision

/// Protocol defining the contract for face detection and image capture services
public protocol FaceDetectionServiceProtocol {
    
    /// Updates the current frame for analysis
    /// - Parameter pixelBuffer: The current camera frame
    func updateCurrentFrame(_ pixelBuffer: CVPixelBuffer)
    
    /// Validates ambient lighting conditions for optimal photo capture
    /// - Returns: Boolean indicating if lighting is adequate
    func checkLight() -> Bool
    
    /// Determines if a face is present and visible in the current frame
    /// - Returns: Boolean indicating if face is visible
    func checkFaceVisibility() -> Bool
    
    /// Detects if any accessories (glasses, hats, etc.) are present
    /// - Returns: Boolean indicating if accessories are detected
    func checkAccessorisExist() -> Bool
    
    /// Captures an image using the camera with completion handler
    /// - Parameter completion: Completion handler that returns UIImage or error
    func captureImage(completion: @escaping (Result<UIImage, Error>) -> Void)
    
    /// Extracts facial landmarks from the current frame
    /// - Returns: Array of face landmarks, or empty array if no face detected
    func getFaceLandmark() -> [CGPoint]
}

/// Result model for image capture operations
public struct ImageResult {
    public let image: UIImage
    public let faceDetected: Bool
    public let lightingAdequate: Bool
    public let accessoriesDetected: Bool
    public let faceLandmarks: [CGPoint]
    public let timestamp: Date
    
    public init(image: UIImage, 
                faceDetected: Bool, 
                lightingAdequate: Bool, 
                accessoriesDetected: Bool, 
                faceLandmarks: [CGPoint]) {
        self.image = image
        self.faceDetected = faceDetected
        self.lightingAdequate = lightingAdequate
        self.accessoriesDetected = accessoriesDetected
        self.faceLandmarks = faceLandmarks
        self.timestamp = Date()
    }
}

/// Concrete implementation of FaceDetectionServiceProtocol
/// Handles face detection, lighting validation, accessories detection, and image capture
public class FaceDetectionService: NSObject, FaceDetectionServiceProtocol {
    
    private var currentFrame: CVPixelBuffer?
    private var faceDetectionRequest: VNDetectFaceRectanglesRequest?
    private var faceLandmarksRequest: VNDetectFaceLandmarksRequest?
    
    // For async photo capture
    private var photoCaptureCompletion: ((Result<UIImage, Error>) -> Void)?
    
    private let minimumLightingThreshold: Float = 0.3
    private let faceConfidenceThreshold: Float = 0.5
    
    public override init() {
        super.init()
        setupVisionRequests()
    }
    
    // Method to update current frame from CameraViewModel
    public func updateCurrentFrame(_ pixelBuffer: CVPixelBuffer) {
        currentFrame = pixelBuffer
    }
    
    
    private func setupVisionRequests() {
        // Face detection request
        faceDetectionRequest = VNDetectFaceRectanglesRequest { request, error in
            if let error = error {
                print("Face detection error: \(error)")
            }
        }
        
        // Face landmarks request
        faceLandmarksRequest = VNDetectFaceLandmarksRequest { request, error in
            if let error = error {
                print("Face landmarks error: \(error)")
            }
        }
    }
    
    
    public func checkLight() -> Bool {
        guard let frame = currentFrame else { return false }
        
        let brightness = AVFoundationHelper.calculateBrightness(from: frame)
        return brightness >= minimumLightingThreshold
    }
    
    public func checkFaceVisibility() -> Bool {
        guard let frame = currentFrame else { return false }
        
        var faceDetected = false
        let semaphore = DispatchSemaphore(value: 0)
        
        VisionHelper.performFaceDetection(on: frame) { observations in
            faceDetected = observations.contains { $0.confidence >= self.faceConfidenceThreshold }
            semaphore.signal()
        }
        
        _ = semaphore.wait(timeout: .now() + 1.0)
        return faceDetected
    }
    
    public func checkAccessorisExist() -> Bool {
        guard let frame = currentFrame else { return false }
        
        var accessoriesDetected = false
        let semaphore = DispatchSemaphore(value: 0)
        
        VisionHelper.performFaceLandmarksDetection(on: frame) { observations in
            for observation in observations {
                if let landmarks = observation.landmarks {
                    // Check for glasses (eyes area)
                    if let leftEye = landmarks.leftEye,
                       let rightEye = landmarks.rightEye {
                        let leftEyePoints = leftEye.normalizedPoints
                        let rightEyePoints = rightEye.normalizedPoints
                        
                        let leftEyeClarity = VisionHelper.calculateLandmarkClarity(leftEyePoints)
                        let rightEyeClarity = VisionHelper.calculateLandmarkClarity(rightEyePoints)
                        
                        if leftEyeClarity < 0.7 || rightEyeClarity < 0.7 {
                            accessoriesDetected = true
                            break
                        }
                    }
                    
                    // Check for hat (forehead area)
                    if let faceContour = landmarks.faceContour {
                        let facePoints = faceContour.normalizedPoints
                        let topFacePoints = facePoints.filter { $0.y < 0.3 }
                        if topFacePoints.count < 3 {
                            accessoriesDetected = true
                            break
                        }
                    }
                }
            }
            semaphore.signal()
        }
        
        _ = semaphore.wait(timeout: .now() + 1.0)
        return accessoriesDetected
    }
    
    // MARK: - REAL APP IMPLEMENTATION
    
    public func captureImage(completion: @escaping (Result<UIImage, Error>) -> Void) {
        // Store completion handler for later use
        photoCaptureCompletion = completion
        
        // Create photo settings
        let settings = AVCapturePhotoSettings()
        
        // Ensure we can capture photos
        guard photoOutput.availablePhotoCodecTypes.contains(.jpeg) else {
            completion(.failure(CameraError.photoCodecNotAvailable))
            return
        }
        
        // Set photo format
        settings.format = [AVVideoCodecKey: AVVideoCodecType.jpeg]
        
        // Capture photo asynchronously
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    public func getFaceLandmark() -> [CGPoint] {
        guard let frame = currentFrame else { return [] }
        
        var landmarks: [CGPoint] = []
        let semaphore = DispatchSemaphore(value: 0)
        
        VisionHelper.performFaceLandmarksDetection(on: frame) { observations in
            for observation in observations {
                if let faceLandmarks = observation.landmarks {
                    let allLandmarks = VisionHelper.extractAllLandmarks(from: faceLandmarks)
                    landmarks.append(contentsOf: allLandmarks)
                }
            }
            semaphore.signal()
        }
        
        _ = semaphore.wait(timeout: .now() + 1.0)
        return landmarks
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension FaceDetectionService: AVCaptureVideoDataOutputSampleBufferDelegate {
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        // Update current frame for analysis
        currentFrame = pixelBuffer
    }
}

// MARK: - AVCapturePhotoCaptureDelegate

extension FaceDetectionService: AVCapturePhotoCaptureDelegate {
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        // Call the stored completion handler
        if let error = error {
            photoCaptureCompletion?(.failure(error))
        } else if let imageData = photo.fileDataRepresentation(),
                  let image = UIImage(data: imageData) {
            photoCaptureCompletion?(.success(image))
        } else {
            photoCaptureCompletion?(.failure(CameraError.imageCreationFailed))
        }
        
        // Clear the completion handler
        photoCaptureCompletion = nil
    }
}

// MARK: - Camera Errors

public enum CameraError: Error {
    case photoCodecNotAvailable
    case imageCreationFailed
    case cameraNotAvailable
    case sessionNotRunning
    
    public var localizedDescription: String {
        switch self {
        case .photoCodecNotAvailable:
            return "Photo codec is not available"
        case .imageCreationFailed:
            return "Failed to create image from photo data"
        case .cameraNotAvailable:
            return "Camera is not available"
        case .sessionNotRunning:
            return "Camera session is not running"
        }
    }
}
