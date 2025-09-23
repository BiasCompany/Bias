//
//  AVFoundation.swift
//  lumi
//
//  Created by Shafa Tiara Tsabita Himawan on 22/09/25.
//
import AVFoundation
import UniformTypeIdentifiers
import UIKit

final class AVFoundationHelper: NSObject {
    let session = AVCaptureSession()
    private var videoDevice: AVCaptureDevice?
    private let photoOutput = AVCapturePhotoOutput()
    private let videoOutput = AVCaptureVideoDataOutput()
    private var currentPhotoDelegate: PhotoDelegate?
    private var currentPhotoContinuation: CheckedContinuation<Data, Error>?
    private var isConfigured = false
    
    var onSampleBuffer: ((CMSampleBuffer) -> Void)?
    
    func configure(sessionPreset: AVCaptureSession.Preset = .high) throws {
        // Only configure if not already configured
        guard !isConfigured else { return }
        
        session.beginConfiguration()
        session.sessionPreset = sessionPreset
        
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            session.commitConfiguration()
            throw NSError(domain: "Camera", code: 1, userInfo: [NSLocalizedDescriptionKey:"No front camera"])
        }
        videoDevice = device
        
        let input = try AVCaptureDeviceInput(device: device)
        guard session.canAddInput(input) else { 
            session.commitConfiguration()
            throw NSError(domain:"Camera", code:2, userInfo:[NSLocalizedDescriptionKey:"Cannot add input"]) 
        }
        session.addInput(input)
        
        guard session.canAddOutput(photoOutput) else { 
            session.commitConfiguration()
            throw NSError(domain:"Camera", code:3, userInfo:[NSLocalizedDescriptionKey:"Cannot add photo output"]) 
        }
        session.addOutput(photoOutput)
//        photoOutput.isHighResolutionCaptureEnabled = true
        
        guard session.canAddOutput(videoOutput) else { 
            session.commitConfiguration()
            throw NSError(domain:"Camera", code:4, userInfo:[NSLocalizedDescriptionKey:"Cannot add video output"]) 
        }
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        videoOutput.alwaysDiscardsLateVideoFrames = true
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "video.sample.queue"))
        session.addOutput(videoOutput)
        videoOutput.connection(with: .video)?.videoOrientation = .portrait
        
        session.commitConfiguration()
        isConfigured = true
    }
    
    func start() { if !session.isRunning { session.startRunning() } }
    func stop()  { if  session.isRunning { session.stopRunning()  } }
    
    func reset() {
        stop()
        isConfigured = false
        // Clear any existing inputs and outputs
        session.beginConfiguration()
        for input in session.inputs {
            session.removeInput(input)
        }
        for output in session.outputs {
            session.removeOutput(output)
        }
        session.commitConfiguration()
    }
    
    func captureJPEGData() async throws -> Data {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        return try await withCheckedThrowingContinuation { (cont: CheckedContinuation<Data, Error>) in
            self.currentPhotoContinuation = cont
            let delegate = PhotoDelegate { [weak self] data, err in
                guard let self = self else { return }
                defer {
                    self.currentPhotoDelegate = nil
                    self.currentPhotoContinuation = nil
                }
                if let err = err {
                    self.currentPhotoContinuation?.resume(throwing: err)
                    return
                }
                guard let data = data else {
                    self.currentPhotoContinuation?.resume(throwing: NSError(domain: "Camera", code: 5, userInfo: [NSLocalizedDescriptionKey: "No photo data"]))
                    return
                }
                self.currentPhotoContinuation?.resume(returning: data)
            }
            self.currentPhotoDelegate = delegate
            self.photoOutput.capturePhoto(with: settings, delegate: delegate)
        }
    }
}

extension AVFoundationHelper: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        onSampleBuffer?(sampleBuffer)
    }
}

private final class PhotoDelegate: NSObject, AVCapturePhotoCaptureDelegate {
    let completion: (Data?, Error?) -> Void
    init(_ completion: @escaping (Data?, Error?) -> Void) { self.completion = completion }
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        completion(photo.fileDataRepresentation(), error)
    }
}
