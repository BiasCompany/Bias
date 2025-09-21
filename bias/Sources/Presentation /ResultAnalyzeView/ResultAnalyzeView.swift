//
//  ResultAnalyzeView.swift
//  bias
//
//  Created by Shafa Tiara Tsabita Himawan on 21/09/25.
//

import SwiftUI

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
    }
    
}

private struct PhotoResultView: View {
    @ObservedObject var viewModel: ResultAnalyzeViewmodel
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                // TODO: Replace with actual captured photo
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .aspectRatio(3/4, contentMode: .fit)
                    .overlay(
                        Text("Captured Photo")
                            .foregroundColor(.white)
                            .font(.title2)
                    )
                
                ForEach(viewModel.detectionPoints) { point in
                    DetectionPointView(
                        point: point,
                        onTap: {
                            viewModel.selectDetectionPoint(point.id)
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            // Instruction text
            Text(viewModel.instructionText)
                .font(.system(.callout, design: .monospaced))
                .fontWeight(.medium)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .padding(.top, 24)

            
            Spacer()
        }
    }
}

private struct ResultView: View {
    @ObservedObject var viewModel: ResultAnalyzeViewmodel
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                // TODO: Replace with actual captured photo
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .aspectRatio(3/4, contentMode: .fit)
                    .overlay(
                        Text("Captured Photo")
                            .foregroundColor(.white)
                            .font(.title2)
                    )
                
                ForEach(viewModel.detectionPoints) { point in
                    DetectionPointView(
                        point: point,
                        isSelected: point.id == viewModel.selectedPointId,
                        onTap: {
                            viewModel.selectDetectionPoint(point.id)
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
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
        Button(action: onTap) {
            circleColor(
                color: point.color,
                diameter: isSelected ? 50 : 38,
                selectedDot: isSelected
            )
        }
        .position(
            x: UIScreen.main.bounds.width * point.position.x,
            y: UIScreen.main.bounds.height * 0.4 * point.position.y + 100
        )
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
