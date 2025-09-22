//
//  LightingAnalyzer.swift
//  lumi
//
//  Created by Shafa Tiara Tsabita Himawan on 22/09/25.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import AVFoundation

final class LightingAnalyzer {
    private let context = CIContext(options: [.useSoftwareRenderer: false])
    private let avgFilter = CIFilter.areaAverage()

    static func status(exposureTargetOffset: Float) -> LightingStatus {
        if exposureTargetOffset > 0.6 { return .tooDark }
        if exposureTargetOffset < -0.6 { return .tooBright }
        return .good
    }

    func status(sampleBuffer: CMSampleBuffer, roiNormalized: CGRect? = nil) -> LightingStatus {
        guard let pb = CMSampleBufferGetImageBuffer(sampleBuffer) else { return .unknown }
        let w = CVPixelBufferGetWidth(pb)
        let h = CVPixelBufferGetHeight(pb)

        var ci = CIImage(cvPixelBuffer: pb)

        if let roi = roiNormalized {
            var rect = CGRect(
                x: roi.minX * CGFloat(w),
                y: (1 - roi.maxY) * CGFloat(h),
                width: roi.width * CGFloat(w),
                height: roi.height * CGFloat(h)
            ).integral

            rect = rect.intersection(ci.extent)
            if !rect.isNull, !rect.isEmpty {
                ci = ci.cropped(to: rect)
            }
        }

        avgFilter.inputImage = ci
        avgFilter.extent = ci.extent
        guard let avg = avgFilter.outputImage else { return .unknown }

        var rgba = [UInt8](repeating: 0, count: 4)
        context.render(
            avg,
            toBitmap: &rgba,
            rowBytes: 4,
            bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
            format: .RGBA8,
            colorSpace: CGColorSpaceCreateDeviceRGB()
        )

        let r = Float(rgba[0]) / 255
        let g = Float(rgba[1]) / 255
        let b = Float(rgba[2]) / 255
        let luma = 0.2126*r + 0.7152*g + 0.0722*b

        if luma < 0.25 { return .tooDark }
        if luma > 0.85 { return .tooBright }
        return .good
    }
}
