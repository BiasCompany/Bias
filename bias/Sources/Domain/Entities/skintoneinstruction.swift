//
//  OnboardingStep.swift
//  bias
//
//  Created by Muhammad Rifqi Syatria on 9/19/25.
//

import SwiftUI

struct SkinToneInstruction {
    let title: String
    let instruction: String
    let duration: Double
    var startTime: Double = 0
    var endTime: Double = 0
}

extension Double {
    /// Format seconds into mm:ss or mm:ss.SS
    func toTimeString() -> String {
        let totalSeconds = Int(self)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        let fraction = Int((self - Double(totalSeconds)) * 100) // 2 decimals
        return String(format: "%02d:%02d.%02d", minutes, seconds, fraction)
    }
}
