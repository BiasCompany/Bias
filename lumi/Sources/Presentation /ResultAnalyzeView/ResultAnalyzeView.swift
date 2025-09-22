//
//  ResultAnalyzeView.swift
//  lumi
//
//  Created by Shafa Tiara Tsabita Himawan on 21/09/25.
//



import SwiftUI
import Vision

struct SkinToneResultView: View {
    @EnvironmentObject var viewModel: ResultAnalyzeViewmodel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            switch viewModel.analysisState {
            case .analyzing:
                AnalyzingView()
                
            case .photoResult:
                PhotoResultView(viewModel: viewModel)
                
            case .result:
                ResultView(viewModel: viewModel)
                
            case .incomplete:
                IncompleteView(viewModel: viewModel)
            }
            
            AnalyzingOverlay(isVisible: $viewModel.isAnalyzingVisible)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .medium))
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text(viewModel.headerTitle)
                    .font(.system(.headline, design: .monospaced))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            
        }
        //        .onAppear {
        //            // 👉 Run Vision when this screen appears
        //            if let image = viewModel.capturedImage {
        //                detectSkinTonePoints(in: image)
        //            }
        //        }
    }
    
    private func detectSkinTonePoints(in image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        
        let request = VNDetectFaceLandmarksRequest { req, err in
            guard let results = req.results as? [VNFaceObservation],
                  let face = results.first,
                  let landmarks = face.landmarks else { return }
            
            let boundingBox = face.boundingBox
            var points: [DetectionPoint] = []
            var nextId = 1
            
            // Forehead (above midpoint of eyes)
            if let leftEye = landmarks.leftEye,
               let rightEye = landmarks.rightEye {
                let leftCorner = leftEye.normalizedPoints[0]
                let rightCorner = rightEye.normalizedPoints[4]
                let midX = (leftCorner.x + rightCorner.x) / 2
                let midY = (leftCorner.y + rightCorner.y) / 2
                let foreheadPoint = CGPoint(x: midX, y: min(midY + 0.25, 1.0))
                points.append(
                    DetectionPoint(
                        id: nextId,
                        position: mapToGlobal(foreheadPoint, in: boundingBox),
                        color: .blue,
                        isSelected: false,
                        isDebug: false
                    )
                )
                nextId += 1
            }
            
            // Cheek (between nose tip & contour)
            if let nose = landmarks.nose,
               let contour = landmarks.faceContour {
                let noseTip = nose.normalizedPoints.last!
                let cheekCandidate = contour.normalizedPoints[contour.pointCount / 4]
                let cheekPoint = CGPoint(x: (noseTip.x + cheekCandidate.x) / 2,
                                         y: (noseTip.y + cheekCandidate.y) / 2)
                points.append(
                    DetectionPoint(
                        id: nextId,
                        position: mapToGlobal(cheekPoint, in: boundingBox),
                        color: .green,
                        isSelected: false,
                        isDebug: false
                    )
                )
                nextId += 1
            }
            
            // Chin (middle of contour, moved upward slightly)
            if let contour = landmarks.faceContour {
                var chinPoint = contour.normalizedPoints[contour.pointCount / 2]
                chinPoint.y += 0.05
                points.append(
                    DetectionPoint(
                        id: nextId,
                        position: mapToGlobal(chinPoint, in: boundingBox),
                        color: .red,
                        isSelected: false,
                        isDebug: false
                    )
                )
                nextId += 1
            }
            
            // --- All Vision landmarks as red debug dots ---
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
                    points.append(
                        DetectionPoint(
                            id: nextId,
                            position: mapToGlobal(pt, in: boundingBox),
                            color: .red,
                            isSelected: false,
                            isDebug: true
                        )
                    )
                    nextId += 1
                }
            }
            
            DispatchQueue.main.async {
                viewModel.detectionPoints = points
            }
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try? handler.perform([request])
    }
    
    
    /// Convert Vision point (normalized inside face bounding box) into global normalized (0–1) for SwiftUI rendering
    private func mapToGlobal(_ point: CGPoint, in boundingBox: CGRect) -> CGPoint {
        let x = boundingBox.origin.x + point.x * boundingBox.size.width
        let y = boundingBox.origin.y + point.y * boundingBox.size.height
        return CGPoint(x: x, y: y)
    }
}


private struct PhotoResultView: View {
    @ObservedObject var viewModel: ResultAnalyzeViewmodel
    
    var body: some View {
        ZStack(){
            GeometryReader { geo in
                if let uiImage = viewModel.capturedImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                    
                    
                        .overlay(
                            GeometryReader { geo in
                                ForEach(viewModel.detectionPoints) { point in
                                    let x = geo.size.width * point.position.x
                                    let y = geo.size.height * (1 - point.position.y)
                                    
                                    if point.isDebug {
                                        
                                        Circle()
                                            .fill(Color.red)
                                            .frame(width: 5, height: 5)
                                            .position(x: x, y: y)
                                    } else {
                                        
                                        VStack(spacing: 2) {
                                            Circle()
                                                .fill(point.color)
                                                .frame(width: 20, height: 20)
                                                .overlay(Circle().stroke(.white, lineWidth: 2))
                                            if let label = point.label {
                                                Text(label)
                                                    .font(.caption2)
                                                    .foregroundColor(.white)
                                                    .shadow(radius: 2)
                                            }
                                        }
                                        .position(x: x, y: y)
                                        .onTapGesture {
                                            viewModel.selectDetectionPoint(point.id)
                                        }
                                    }
                                }
                            }
                        )
                    
                    
                }
            }
            VStack() {
                
                Spacer()
                Spacer()
                Spacer()
                
                
                Text(viewModel.instructionText)
                    .frame(maxWidth: .infinity)
                    .font(.system(.callout, design: .monospaced))
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .padding(.top, 24)
                    .background{
                        BlackGradientView()
                            .frame(height:200 )
                            .ignoresSafeArea(edges: .bottom)
                    }
                
                Spacer()
            }
        }
        .ignoresSafeArea(.all)
    }
}



private struct ResultView: View {
    @ObservedObject var viewModel: ResultAnalyzeViewmodel
    
    var body: some View {
        VStack(spacing: 0) {
            if let uiImage = viewModel.capturedImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .aspectRatio(contentMode: .fit)
                    .overlay(
                        GeometryReader { geo in
                            ForEach(viewModel.detectionPoints) { point in
                                let x = geo.size.width * point.position.x
                                let y = geo.size.height * (1 - point.position.y)
                                
                                if point.isDebug {
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 5, height: 5)
                                        .position(x: x, y: y)
                                } else {
                                    VStack(spacing: 2) {
                                        Circle()
                                            .fill(point.color)
                                            .frame(width: 20, height: 20)
                                            .overlay(Circle().stroke(.white, lineWidth: 2))
                                        if let label = point.label {
                                            Text(label)
                                                .font(.caption2)
                                                .foregroundColor(.white)
                                                .shadow(radius: 2)
                                        }
                                    }
                                    .position(x: x, y: y)
                                    .onTapGesture {
                                        viewModel.selectDetectionPoint(point.id)
                                    }
                                }
                            }
                        }
                    )
            } else {
                Image("syatria")
                    .resizable()
                    .scaledToFill()
                    .aspectRatio(3 / 4, contentMode: .fit)
                    .clipped()
            }
            
            Spacer()
            
            SkinTonePanel(
                toneText: viewModel.currentSkinToneText,
                background: viewModel.panelBackgroundColor,
                onFindShade: {
                    viewModel.findMyShade()
                }
            )
        }
    }
}


private struct IncompleteView: View {
    @ObservedObject var viewModel: ResultAnalyzeViewmodel
    
    var body: some View {
        SkinToneFailedView(onRetake: {
            viewModel.retakePhoto()
        })
    }
}

private struct DetectionPointView: View {
    let point: DetectionPoint
    var isSelected: Bool = false
    let onTap: () -> Void
    
    var body: some View {
        GeometryReader { geo in
            Button(action: onTap) {
                circleColor(
                    color: point.color,
                    diameter: isSelected ? 6 : 6,
                    selectedDot: isSelected
                )
            }
            .position(
                x: geo.size.width * point.position.x,
                y: geo.size.height * (1 - point.position.y) // flip Y for Vision → SwiftUI
            )
        }
    }
}


// MARK: - Previews
#Preview("SkinToneResultView – Analyzing") {
    let vm = ResultAnalyzeViewmodel()
    vm.analysisState = .analyzing
    vm.isAnalyzingVisible = true
    return SkinToneResultView()
        .environmentObject(vm)
}

#Preview("SkinToneResultView – Photo Result") {
    let vm = ResultAnalyzeViewmodel()
    vm.analysisState = .photoResult
    vm.isAnalyzingVisible = false
    return SkinToneResultView()
        .environmentObject(vm)
}

#Preview("SkinToneResultView – Result") {
    let vm = ResultAnalyzeViewmodel()
    
    vm.analysisState = .result
    vm.selectedSkinTone = "MEDIUM"
    vm.isAnalyzingVisible = false
    return SkinToneResultView()
        .environmentObject(vm)
}

#Preview("SkinToneResultView – Incomplete") {
    let vm = ResultAnalyzeViewmodel()
    vm.analysisState = .incomplete
    vm.isAnalyzingVisible = false
    return SkinToneResultView()
        .environmentObject(vm)
}



