import SwiftUI
import Vision
import UIKit

struct SamplePoint: Identifiable {
    let id = UUID()
    let position: CGPoint   // pixel coordinate in the image
    let hex: String
    let label: String
    let isDebug: Bool       // true = landmark pin, false = sampled color point
}

struct LandmarkColorExtractorView: View {
    @State private var selectedImage: UIImage?
    @State private var samplePoints: [SamplePoint] = []
    @State private var showPicker = false
    
    var body: some View {
        VStack {
            if let image = selectedImage {
                ZStack {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 300)
                        .overlay(
                            GeometryReader { geo in
                                ForEach(samplePoints) { point in
                                    let scaleX = geo.size.width / image.size.width
                                    let scaleY = geo.size.height / image.size.height
                                    let scale = min(scaleX, scaleY)
                                    let offsetX = (geo.size.width - image.size.width * scale) / 2
                                    let offsetY = (geo.size.height - image.size.height * scale) / 2
                                    
                                    let localX = point.position.x * scale + offsetX
                                    let localY = point.position.y * scale + offsetY
                                    
                                    if point.isDebug {
                                        // Small red dot for raw landmarks
                                        Circle()
                                            .fill(Color.red)
                                            .frame(width: 5, height: 5)
                                            .position(x: localX, y: localY)
                                    } else {
                                        // Bigger colored circle for forehead/cheek/chin
                                        VStack(spacing: 2) {
                                            Circle()
                                                .fill(Color(hex: point.hex))
                                                .frame(width: 20, height: 20)
                                                .overlay(Circle().stroke(.white, lineWidth: 2))
                                            Text(point.label)
                                                .font(.caption2)
                                                .foregroundColor(.white)
                                                .shadow(radius: 2)
                                        }
                                        .position(x: localX, y: localY)
                                    }
                                }
                            }
                        )
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(samplePoints.filter { !$0.isDebug }) { point in
                        Text("\(point.label): \(point.hex)")
                            .font(.system(size: 14, weight: .medium, design: .monospaced))
                    }
                }
                .padding()
            } else {
                Text("Select an image")
                    .foregroundColor(.gray)
                    .padding()
            }
            
            Button("Pick Image") {
                showPicker = true
            }
            .padding()
        }
        .sheet(isPresented: $showPicker) {
            ImagePicker(image: $selectedImage, onImagePicked: processImage)
        }
    }
    
    // MARK: - Vision Processing
    private func processImage(_ image: UIImage) {
        samplePoints = []
        guard let cgImage = image.cgImage else { return }
        
        let request = VNDetectFaceLandmarksRequest { request, error in
            guard let results = request.results as? [VNFaceObservation],
                  let face = results.first,
                  let landmarks = face.landmarks else { return }
            
            let size = CGSize(width: cgImage.width, height: cgImage.height)
            let boundingBox = face.boundingBox
            
            // --- Forehead (above eyes) ---
            if let leftEye = landmarks.leftEye,
               let rightEye = landmarks.rightEye {
                let leftCorner = leftEye.normalizedPoints[0]
                let rightCorner = rightEye.normalizedPoints[4]
                let midX = (leftCorner.x + rightCorner.x) / 2
                let midY = (leftCorner.y + rightCorner.y) / 2
                let foreheadPoint = CGPoint(x: midX+0.1, y: max(midY+0.25, 0.0))
                let pixel = convert(foreheadPoint, in: boundingBox, imageSize: size)
                if let color = color(at: pixel, in: image) {
                    samplePoints.append(SamplePoint(position: pixel, hex: color.toHexString(), label: "Forehead", isDebug: false))
                }
            }
            
            // --- Cheek (between nose tip and left contour) ---
            if let nose = landmarks.nose,
               let contour = landmarks.faceContour {
                let noseTip = nose.normalizedPoints.last!
                let cheekCandidate = contour.normalizedPoints[contour.pointCount / 4]
                let cheekPoint = CGPoint(x: ((noseTip.x + cheekCandidate.x) / 2)+0.1,
                                         y: ((noseTip.y + cheekCandidate.y) / 2)+0.07)
                let pixel = convert(cheekPoint, in: boundingBox, imageSize: size)
                if let color = color(at: pixel, in: image) {
                    samplePoints.append(SamplePoint(position: pixel, hex: color.toHexString(), label: "Cheek", isDebug: false))
                }
            }
            
            // --- Chin (middle of face contour, adjusted upward) ---
            if let contour = landmarks.faceContour {
                var chinPoint = contour.normalizedPoints[contour.pointCount / 2]
                
                // Move up a little (tweak 0.05–0.1 depending on how far you want)
                chinPoint.y += 0.05
                chinPoint.y = min(chinPoint.y, 1.0) // keep inside face box
                
                let pixel = convert(chinPoint, in: boundingBox, imageSize: size)
                if let color = color(at: pixel, in: image) {
                    samplePoints.append(
                        SamplePoint(position: pixel,
                                    hex: color.toHexString(),
                                    label: "Chin",
                                    isDebug: false)
                    )
                }
            }

            
            // --- Show ALL raw landmark points as red pins ---
            let regions: [VNFaceLandmarkRegion2D?] = [
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
            
            for region in regions.compactMap({ $0 }) {
                for point in region.normalizedPoints {
                    let pixel = convert(point, in: boundingBox, imageSize: size)
                    samplePoints.append(SamplePoint(position: pixel, hex: "#FF0000", label: "", isDebug: true))
                }
            }
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try? handler.perform([request])
    }
}

// MARK: - Helpers

func convert(_ point: CGPoint, in boundingBox: CGRect, imageSize: CGSize) -> CGPoint {
    // Vision gives normalized coordinates (0–1), origin bottom-left, relative to bounding box
    let x = boundingBox.origin.x * imageSize.width + point.x * boundingBox.size.width * imageSize.width
    
    // Correct Y-axis: flip from Vision (bottom-left) to CoreGraphics (top-left)
    let y = (1 - boundingBox.origin.y - point.y * boundingBox.size.height) * imageSize.height
    
    return CGPoint(x: x, y: y)
}


func color(at point: CGPoint, in image: UIImage) -> UIColor? {
    guard let cgImage = image.cgImage,
          let data = cgImage.dataProvider?.data,
          let ptr = CFDataGetBytePtr(data) else { return nil }
    
    let bytesPerPixel = 4
    let bytesPerRow = cgImage.bytesPerRow
    let x = Int(point.x)
    let y = Int(point.y)
    
    if x < 0 || y < 0 || x >= cgImage.width || y >= cgImage.height { return nil }
    
    let offset = y * bytesPerRow + x * bytesPerPixel
    let r = CGFloat(ptr[offset]) / 255.0
    let g = CGFloat(ptr[offset+1]) / 255.0
    let b = CGFloat(ptr[offset+2]) / 255.0
    let a = CGFloat(ptr[offset+3]) / 255.0
    
    return UIColor(red: r, green: g, blue: b, alpha: a)
}

extension UIColor {
    func toHexString() -> String {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return String(format: "#%02lX%02lX%02lX",
                      lroundf(Float(r * 255)),
                      lroundf(Float(g * 255)),
                      lroundf(Float(b * 255)))
    }
}
