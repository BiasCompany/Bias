//
//  ResultAnalyzeViewmodel.swift
//  bias
//
//  Created by Shafa Tiara Tsabita Himawan on 21/09/25.
//

import SwiftUI
import Combine

@MainActor
final class ResultAnalyzeViewmodel: ObservableObject {
    @Published var analysisState: AnalysisState = .analyzing
    @Published var selectedSkinTone: String = ""
    @Published var detectedSkinTone: String = "MEDIUM" // TODO: ganti hasil deteksi beneran
    @Published var isAnalyzingVisible: Bool = true

    // MARK: - Hardcoded Detection Points (TODO: Replace with actual face detection)
    @Published var detectionPoints: [DetectionPoint] = [
        DetectionPoint(id: 1, position: CGPoint(x: 0.3, y: 0.2), color: .init(red: 0.85, green: 0.75, blue: 0.65)),
        DetectionPoint(id: 2, position: CGPoint(x: 0.2, y: 0.5), color: .init(red: 0.8, green: 0.7, blue: 0.6)),
        DetectionPoint(id: 3, position: CGPoint(x: 0.8, y: 0.5), color: .init(red: 0.75, green: 0.65, blue: 0.55)),
        DetectionPoint(id: 4, position: CGPoint(x: 0.5, y: 0.7), color: .init(red: 0.7, green: 0.6, blue: 0.5)),
        DetectionPoint(id: 5, position: CGPoint(x: 0.5, y: 0.6), color: .init(red: 0.8, green: 0.7, blue: 0.6))
    ]

    var onFindShade: (() -> Void)?
    var onRetake: (() -> Void)?

    private var cancellables = Set<AnyCancellable>()

    init() {
        startAnalysis()
    }
    
    

    func selectSkinTone(_ skinTone: String) {
        selectedSkinTone = skinTone
        analysisState = .result
    }

    func findMyShade() {
        // Belum routing
        onFindShade?()
    }

    func retakePhoto() {
        // Belum routing
        onRetake?()
    }

    func selectDetectionPoint(_ pointId: Int) {
        if let point = detectionPoints.first(where: { $0.id == pointId }) {
            selectedSkinTone = getSkinToneFromColor(point.color)
            analysisState = .result
        }
    }

    private func startAnalysis() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.isAnalyzingVisible = false
            self.analysisState = .photoResult
        }
    }
    
    // TODO: Implement actual color analysis to determine skin tone
    func getSkinToneFromColor(_ color: Color) -> String {
        let uiColor = UIColor(color)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)

        if r > 0.8 && g > 0.7 && b > 0.6 { return "LIGHT" }
        else if r > 0.7 && g > 0.6 && b > 0.5 { return "MEDIUM" }
        else { return "DARK" }
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

    var currentSkinToneText: String {
        selectedSkinTone.isEmpty ? detectedSkinTone : selectedSkinTone
    }

    var selectedPointId: Int? {
        detectionPoints.first { getSkinToneFromColor($0.color) == selectedSkinTone }?.id
    }

    var panelBackgroundColor: Color {
        Color(red: 210/255, green: 170/255, blue: 150/255)
    }
}


enum AnalysisState {
    case analyzing, photoResult, result, incomplete
}

struct DetectionPoint: Identifiable {
    let id: Int
    let position: CGPoint
    let color: Color
    var isSelected: Bool = false
}
