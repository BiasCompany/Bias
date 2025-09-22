//
//  ResultAnalyzeViewmodel.swift
//  lumi
//
//  Created by Shafa Tiara Tsabita Himawan on 21/09/25.
//

import Combine
import SwiftUI
import Vision

@MainActor
final class ResultAnalyzeViewmodel: ObservableObject {
    @Published var analysisState: AnalysisState = .analyzing
    @Published var selectedSkinTone: String = ""
    @Published var detectedSkinTone: String = "MEDIUM"  // TODO: replace with real detection
    @Published var panelBackgroundColor: Color = .gray
    @Published var currentSkinToneText: String = ""

    @Published var isAnalyzingVisible: Bool = true
    @Published var selectedPointId: Int? = nil
    @Published var detectionPoints: [DetectionPoint] = []
    

    /// Captured photo from camera
    @Published var capturedImage: UIImage?

    var onFindShade: (() -> Void)?
    var onRetake: (() -> Void)?

    private var cancellables = Set<AnyCancellable>()

    init() {
        if let img = UIImage(named: "syatria") {
            self.capturedImage = img
            detectSkinTonePoints(in: img)
        }
        startAnalysis()
    }
    

    
    func selectDetectionPoint(_ pointId: Int) {
        if let point = detectionPoints.first(where: { $0.id == pointId }) {
            selectedPointId = point.id
            
            // Store skin tone label (LIGHT / MEDIUM / DARK)
            selectedSkinTone = getSkinToneFromColor(point.color)
            
            // Update panel background to the tapped color
            panelBackgroundColor = point.color
            
            // Update text to show hex code instead of just LIGHT/MEDIUM/DARK
            currentSkinToneText = point.color.toHexString()
            
            analysisState = .result
        }
    }




    // MARK: - Vision Landmark Detection
    func detectSkinTonePoints(in image: UIImage) {
        guard let cgImage = image.cgImage else { return }

        let request = VNDetectFaceLandmarksRequest { [weak self] req, err in
            guard let self = self,
                  let results = req.results as? [VNFaceObservation],
                  let face = results.first,
                  let landmarks = face.landmarks else { return }

            let boundingBox = face.boundingBox
            var points: [DetectionPoint] = []
            var nextId = 1

            // Forehead (midpoint of eyes, shifted upward)
            if let leftEye = landmarks.leftEye,
               let rightEye = landmarks.rightEye {
                let leftCorner = leftEye.normalizedPoints[0]
                let rightCorner = rightEye.normalizedPoints[4]
                let midX = (leftCorner.x + rightCorner.x) / 2
                let midY = (leftCorner.y + rightCorner.y) / 2
                let foreheadPoint = CGPoint(x: midX, y: min(midY + 0.25, 1.0))
                let global = Self.mapToGlobal(foreheadPoint, in: boundingBox)
                let color = self.sampleColor(at: global, in: image)
                points.append(DetectionPoint(id: nextId, position: global, color: color))
                nextId += 1
            }

            // Cheek (between nose tip & contour)
            if let nose = landmarks.nose,
               let contour = landmarks.faceContour {
                let noseTip = nose.normalizedPoints.last!
                let cheekCandidate = contour.normalizedPoints[contour.pointCount / 4]
                let cheekPoint = CGPoint(x: (noseTip.x + cheekCandidate.x) / 2,
                                         y: (noseTip.y + cheekCandidate.y) / 2)
                let global = Self.mapToGlobal(cheekPoint, in: boundingBox)
                let color = self.sampleColor(at: global, in: image)
                points.append(DetectionPoint(id: nextId, position: global, color: color))
                nextId += 1
            }

            // Chin (middle of contour, moved upward slightly)
            if let contour = landmarks.faceContour {
                var chinPoint = contour.normalizedPoints[contour.pointCount / 2]
                chinPoint.y += 0.05 // move upward
                let global = Self.mapToGlobal(chinPoint, in: boundingBox)
                let color = self.sampleColor(at: global, in: image)
                points.append(DetectionPoint(id: nextId, position: global, color: color))
                nextId += 1
            }
            
            // --- Show ALL raw landmark points as red dots (debug) ---
            let allRegions: [VNFaceLandmarkRegion2D?] = [
                landmarks.faceContour,
                landmarks.leftEye,
                landmarks.rightEye,
                landmarks.leftEyebrow,
                landmarks.rightEyebrow,
                landmarks.nose,
                landmarks.noseCrest,
                landmarks.outerLips,
                landmarks.innerLips,
                landmarks.medianLine
            ]

            for region in allRegions.compactMap({ $0 }) {
                for pt in region.normalizedPoints {
                    let global = Self.mapToGlobal(pt, in: boundingBox)
                    points.append(
                        DetectionPoint(
                            id: nextId,
                            position: global,
                            color: .red,
                            isSelected: false,
                            isDebug: true
                        )
                    )
                    nextId += 1
                }
            }


            DispatchQueue.main.async {
                self.detectionPoints = points
            }
        }

        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try? handler.perform([request])
    }

    /// Convert Vision-local normalized point into global normalized (0–1) coordinates
    private static func mapToGlobal(_ point: CGPoint, in boundingBox: CGRect) -> CGPoint {
        let x = boundingBox.origin.x + point.x * boundingBox.size.width
        let y = boundingBox.origin.y + point.y * boundingBox.size.height
        return CGPoint(x: x, y: y)
    }

    /// Sample actual pixel color from UIImage at normalized coordinate
    private func sampleColor(at normPoint: CGPoint, in image: UIImage) -> Color {
        guard let cgImage = image.cgImage else { return .gray }
        let x = Int(normPoint.x * CGFloat(cgImage.width))
        let y = Int((1 - normPoint.y) * CGFloat(cgImage.height)) // flip Y
        guard let data = cgImage.dataProvider?.data,
              let ptr = CFDataGetBytePtr(data) else { return .gray }

        let bytesPerPixel = 4
        let bytesPerRow = cgImage.bytesPerRow
        if x < 0 || y < 0 || x >= cgImage.width || y >= cgImage.height {
            return .gray
        }

        let offset = y * bytesPerRow + x * bytesPerPixel
        let r = Double(ptr[offset]) / 255.0
        let g = Double(ptr[offset+1]) / 255.0
        let b = Double(ptr[offset+2]) / 255.0

        return Color(red: r, green: g, blue: b)
    }

    // MARK: - User Actions
    func selectSkinTone(_ skinTone: String) {
        selectedSkinTone = skinTone
        analysisState = .result
    }

    func findMyShade() {
        onFindShade?()
    }

    func retakePhoto() {
        onRetake?()
    }

    

    private func startAnalysis() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.isAnalyzingVisible = false
            self.analysisState = .photoResult
        }
    }

    // MARK: - Color → Skin Tone mapping
    func getSkinToneFromColor(_ color: Color) -> String {
        let uiColor = UIColor(color)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)

        if r > 0.8 && g > 0.7 && b > 0.6 {
            return "LIGHT"
        } else if r > 0.7 && g > 0.6 && b > 0.5 {
            return "MEDIUM"
        } else {
            return "DARK"
        }
    }
}

extension ResultAnalyzeViewmodel {
    var headerTitle: String {
        switch analysisState {
        case .analyzing:
            return "Check Skin Tone - Process Analyzing"
        case .photoResult, .result:
            return "YOUR PHOTO RESULT"
        case .incomplete:
            return "Check Skin Tone - Analysis Failed"
        }
    }

    var instructionText: String {
        "TAP THE CIRCLE THAT DESCRIBES YOUR SKIN TONE THE BEST"
    }

    
}

enum AnalysisState {
    case analyzing, photoResult, result, incomplete
}

struct DetectionPoint: Identifiable {
    let id: Int
    let position: CGPoint   // normalized [0–1]
    let color: Color
    var isSelected: Bool = false
    var isDebug: Bool = false
    var label: String? = nil
}


