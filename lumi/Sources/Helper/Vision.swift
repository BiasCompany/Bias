//
//  Vision.swift
//  lumi
//
//  Created by Shafa Tiara Tsabita Himawan on 22/09/25.
//

import Vision
import AVFoundation

final class VisionFaceHelper {
    private let sequenceHandler = VNSequenceRequestHandler()
    
    func analyze(sampleBuffer: CMSampleBuffer) throws -> FaceAnalysis? {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        let faceReq = VNDetectFaceRectanglesRequest()
        let lmReq = VNDetectFaceLandmarksRequest()
        let qReq = VNDetectFaceCaptureQualityRequest()
        try sequenceHandler.perform([faceReq, lmReq, qReq], on: pixelBuffer, orientation: .up)
        
        guard let face = faceReq.results?.first as? VNFaceObservation else { return nil }
        let lm = (lmReq.results?.first as? VNFaceObservation)?.landmarks
        let q = (qReq.results?.first as? VNFaceObservation)?.faceCaptureQuality
        
        return FaceAnalysis(
            faceRectNormalized: face.boundingBox,
            landmarks: lm,
            roll: face.roll?.floatValue,
            yaw: face.yaw?.floatValue,
            captureQuality: q
        )
    }
}

