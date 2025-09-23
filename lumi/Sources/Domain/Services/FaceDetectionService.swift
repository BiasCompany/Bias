//
//  FaceDetectionService.swift
//  lumi
//
//  Created by Muhammad Rifqi Syatria on 9/17/25.
//
import Foundation
import AVFoundation
import Vision
import UIKit

protocol FaceDetectionServiceProtocol: AnyObject {
        var captureSession: AVCaptureSession { get }
        func start() throws
        func stop()
        func reset()
        func checkLight() -> LightingStatus
        func checkFaceVisibility() -> (visible: Bool, analysis: FaceAnalysis?)
        func checkAccessoriesExist() -> AccessoryStatus
        func captureImage() async throws -> UIImage
}

public struct FaceAnalysis {
    public let faceRectNormalized: CGRect
    public let landmarks: VNFaceLandmarks2D?
    public let roll: Float?
    public let yaw: Float?
    public let captureQuality: Float?
}

public enum LightingStatus: String { case tooDark, tooBright, good, unknown }
public enum AccessoryStatus: String { case none, glasses, sunglasses, mask, occlusion, unknown }


class FaceDetectionService: FaceDetectionServiceProtocol {
    func captureImage() async throws -> UIImage {
        let data = try await camera.captureJPEGData()
        guard let image = UIImage(data: data) else {
            throw NSError(
                domain: "FaceDetectionService",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Invalid JPEG data"]
            )
        }
        return image
    }
    
    private let camera: AVFoundationHelper
    private let vision: VisionFaceHelper
    private let lighting: LightingAnalyzer
    private let accessories: AccessoryDetectorHeuristic
       
    private var latestSampleBuffer: CMSampleBuffer?
    private var lastFaceAnalysis: FaceAnalysis?
    private var lastVisible: Bool = false
    public var captureSession: AVCaptureSession { camera.session }
    
    public init(
        camera: AVFoundationHelper = .init(),
        vision: VisionFaceHelper = .init(),
        lighting: LightingAnalyzer = .init(),
        accessories: AccessoryDetectorHeuristic = .init()
    ) {
        self.camera = camera
        self.vision = vision
        self.lighting = lighting
        self.accessories = accessories
        
        self.camera.onSampleBuffer = { [weak self] sb in
            self?.latestSampleBuffer = sb
        }
    }
    
    public func start() throws {
        try camera.configure()
        camera.start()
    }
    
    public func stop() {
        camera.stop()
    }
    
    public func reset() {
        camera.reset()
        latestSampleBuffer = nil
        lastFaceAnalysis = nil
        lastVisible = false
    }
    
    
    public func checkLight() -> LightingStatus {
        guard let sb = latestSampleBuffer else { return .unknown }
        return lighting.status(sampleBuffer: sb)
    }
    
    public func checkFaceVisibility() -> (visible: Bool, analysis: FaceAnalysis?) {
        guard let sb = latestSampleBuffer,
        let a  = try? vision.analyze(sampleBuffer: sb) else {
            lastFaceAnalysis = nil
            lastVisible = false
            return (false, nil)
        }

        let box = a.faceRectNormalized
        let area = box.width * box.height
        let centerSafe = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
        let limitedRotation = abs(a.yaw ?? 0) < .pi/8 && abs(a.roll ?? 0) < .pi/8
        let visible = area > 0.15 && centerSafe.contains(CGPoint(x: box.midX, y: box.midY)) && limitedRotation

        lastFaceAnalysis = a
        lastVisible = visible
        return (visible, a)
    }
    
    private var accessoryState: AccessoryStatus = .unknown
       private var accYesCount = 0
       private var accNoCount  = 0
       private let accThreshold = 3
    public func checkAccessoriesExist() -> AccessoryStatus {
         guard lastVisible, let a = lastFaceAnalysis, let sb = latestSampleBuffer else {
             accYesCount = 0; accNoCount = 0
             accessoryState = .unknown
             return .unknown
         }

         if (a.captureQuality ?? 1) < 0.45 {
             return .unknown
         }

         let candidate = accessories.detect(on: sb,
                                            faceRect: a.faceRectNormalized,
                                            landmarks: a.landmarks)

         switch candidate {
         case .glasses, .sunglasses, .mask, .occlusion:
             accYesCount += 1; accNoCount = 0
             if accYesCount >= accThreshold { accessoryState = candidate }
         case .none:
             accNoCount += 1; accYesCount = 0
             if accNoCount >= accThreshold { accessoryState = .none }
         default:
             break
         }
         return accessoryState
     }
    

}
