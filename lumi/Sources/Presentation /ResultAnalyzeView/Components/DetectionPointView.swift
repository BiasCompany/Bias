//
//  DetectionPointView.swift
//  lumi
//
//  Created by Muhammad Rifqi Syatria on 9/23/25.
//


import SwiftUI
import Vision

 struct DetectionPointView: View {
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
