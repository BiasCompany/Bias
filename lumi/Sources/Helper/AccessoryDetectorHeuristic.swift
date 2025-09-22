//
//  AccessoryDetectorHeuristic.swift
//  lumi
//
//  Created by Shafa Tiara Tsabita Himawan on 22/09/25.
//

import Vision
import AVFoundation
import CoreGraphics

final class AccessoryDetectorHeuristic {

    func detect(on sampleBuffer: CMSampleBuffer,
                faceRect: CGRect?,
                landmarks: VNFaceLandmarks2D?) -> AccessoryStatus {
        guard let pb = CMSampleBufferGetImageBuffer(sampleBuffer),
              let faceRect
        else { return .unknown }

        guard CVPixelBufferGetPixelFormatType(pb) == kCVPixelFormatType_32BGRA else { return .unknown }

        let hasLeftEye  = !(landmarks?.leftEye?.normalizedPoints.isEmpty ?? true)
        let hasRightEye = !(landmarks?.rightEye?.normalizedPoints.isEmpty ?? true)
        let hasBrows    = !(landmarks?.leftEyebrow?.normalizedPoints.isEmpty ?? true) ||
                          !(landmarks?.rightEyebrow?.normalizedPoints.isEmpty ?? true)
        let hasNose     = !(landmarks?.nose?.normalizedPoints.isEmpty ?? true) ||
                          !(landmarks?.noseCrest?.normalizedPoints.isEmpty ?? true)
        let hasLips     = !(landmarks?.outerLips?.normalizedPoints.isEmpty ?? true)

        let minArea: CGFloat = 0.08
        if faceRect.width * faceRect.height < minArea { return .unknown }

        let fx = faceRect.minX, fy = faceRect.minY
        let fw = faceRect.width, fh = faceRect.height

        let cheekW = fw * 0.18
        let cheekH = fh * 0.18
        let leftCheek  = CGRect(x: fx + fw*0.18, y: fy + fh*0.35, width: cheekW, height: cheekH)
        let rightCheek = CGRect(x: fx + fw*0.64, y: fy + fh*0.35, width: cheekW, height: cheekH)

        let eyeBand = CGRect(x: fx + fw*0.10,
                             y: fy + fh*0.60,
                             width: fw*0.80,
                             height: fh*0.22)

        let lowerBand = CGRect(x: fx + fw*0.15,
                               y: fy + fh*0.00,
                               width: fw*0.70,
                               height: fh*0.45)

        let cheekSkinL = SkinHeuristics.skinAndLuma(in: leftCheek,  pixelBuffer: pb)
        let cheekSkinR = SkinHeuristics.skinAndLuma(in: rightCheek, pixelBuffer: pb)
        let cheekSkin  = max((cheekSkinL.skin + cheekSkinR.skin) / 2, 0.001)
        let cheekLuma  = max((cheekSkinL.luma + cheekSkinR.luma) / 2, 0.001)

        if cheekSkin < 0.05 { return .unknown }

        let eyeSkinLuma  = SkinHeuristics.skinAndLuma(in: eyeBand, pixelBuffer: pb)
        let lowerSkinLuma = SkinHeuristics.skinAndLuma(in: lowerBand, pixelBuffer: pb)

        let eyeVsCheekSkin   = eyeSkinLuma.skin / cheekSkin
        let lowerVsCheekSkin = lowerSkinLuma.skin / cheekSkin
        let eyeVsCheekLuma   = max(eyeSkinLuma.luma / cheekLuma, 0.0001)

        let glareRatio = SkinHeuristics.glareRatio(in: eyeBand, pixelBuffer: pb)
        let edgeDensity = SkinHeuristics.edgeDensity(in: eyeBand, pixelBuffer: pb)


        if eyeVsCheekLuma < 0.60 || eyeVsCheekSkin < 0.25 {
            return .sunglasses
        }

        let eyesPresent = hasLeftEye && hasRightEye
        let notMaskHint = lowerVsCheekSkin >= 0.40 && (hasNose || hasLips)
        if eyesPresent && notMaskHint && (glareRatio > 0.035 || edgeDensity > 0.09) {
            return .glasses
        }

        let eyeLumaNearCheek = (eyeVsCheekLuma > 0.80 && eyeVsCheekLuma < 1.20)
        let eyeSkinNearCheek = (eyeVsCheekSkin > 0.50 && eyeVsCheekSkin < 1.20)
        if eyesPresent && notMaskHint && eyeLumaNearCheek && eyeSkinNearCheek &&
            (glareRatio > 0.020 || edgeDensity > 0.060 || !hasBrows) {
            return .glasses
        }

        if (!hasNose || !hasLips) || lowerVsCheekSkin < 0.55 {
            return .mask
        }

        let missing = [hasLeftEye, hasRightEye, hasNose, hasLips].filter { !$0 }.count
        if missing >= 2 { return .occlusion }

        return .none
    }
}

enum SkinHeuristics {

    static func skinAndLuma(in normRect: CGRect, pixelBuffer: CVPixelBuffer) -> (skin: CGFloat, luma: CGFloat) {
        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly) }
        guard let base = CVPixelBufferGetBaseAddress(pixelBuffer) else { return (0,0) }
        let w = CVPixelBufferGetWidth(pixelBuffer)
        let h = CVPixelBufferGetHeight(pixelBuffer)
        let bpr = CVPixelBufferGetBytesPerRow(pixelBuffer)

        let r = denormVisionRect(normRect, width: w, height: h)
        if r.isEmpty { return (0,0) }

        let step = max(1, min(r.width, r.height) / 64)
        var skin = 0, total = 0
        var lumaSum: Float = 0

        for y in stride(from: Int(r.minY), to: Int(r.maxY), by: Int(step)) {
            let row = base.advanced(by: y * bpr)
            for x in stride(from: Int(r.minX), to: Int(r.maxX), by: Int(step)) {
                let p = row.advanced(by: x * 4)
                let b = Float(p.load(fromByteOffset: 0, as: UInt8.self)) / 255
                let g = Float(p.load(fromByteOffset: 1, as: UInt8.self)) / 255
                let r = Float(p.load(fromByteOffset: 2, as: UInt8.self)) / 255
                if isSkin(r: r, g: g, b: b) { skin += 1 }
                let y = 0.2126*r + 0.7152*g + 0.0722*b
                lumaSum += y
                total += 1
            }
        }
        let skinRatio = total == 0 ? 0 : CGFloat(skin) / CGFloat(total)
        let lumaAvg   = total == 0 ? 0 : CGFloat(lumaSum / Float(total))
        return (skinRatio, lumaAvg)
    }

    static func glareRatio(in normRect: CGRect, pixelBuffer: CVPixelBuffer) -> CGFloat {
        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly) }
        guard let base = CVPixelBufferGetBaseAddress(pixelBuffer) else { return 0 }
        let w = CVPixelBufferGetWidth(pixelBuffer)
        let h = CVPixelBufferGetHeight(pixelBuffer)
        let bpr = CVPixelBufferGetBytesPerRow(pixelBuffer)

        let r = denormVisionRect(normRect, width: w, height: h)
        if r.isEmpty { return 0 }

        let step = max(1, min(r.width, r.height) / 64)
        var glare = 0, total = 0

        for y in stride(from: Int(r.minY), to: Int(r.maxY), by: Int(step)) {
            let row = base.advanced(by: y * bpr)
            for x in stride(from: Int(r.minX), to: Int(r.maxX), by: Int(step)) {
                let p = row.advanced(by: x * 4)
                let b = Float(p.load(fromByteOffset: 0, as: UInt8.self)) / 255
                let g = Float(p.load(fromByteOffset: 1, as: UInt8.self)) / 255
                let r = Float(p.load(fromByteOffset: 2, as: UInt8.self)) / 255
                let (_,s,v) = toHSV(r, g, b)
                if s < 0.15 && v > 0.85 { glare += 1 }
                total += 1
            }
        }
        return total == 0 ? 0 : CGFloat(glare) / CGFloat(total)
    }

    static func edgeDensity(in normRect: CGRect, pixelBuffer: CVPixelBuffer) -> CGFloat {
        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly) }
        guard let base = CVPixelBufferGetBaseAddress(pixelBuffer) else { return 0 }
        let w = CVPixelBufferGetWidth(pixelBuffer)
        let h = CVPixelBufferGetHeight(pixelBuffer)
        let bpr = CVPixelBufferGetBytesPerRow(pixelBuffer)

        let r = denormVisionRect(normRect, width: w, height: h)
        if r.width < 4 || r.height < 4 { return 0 }

        let step = max(1, min(r.width, r.height) / 64)
        var strongEdges = 0, total = 0

        for y in stride(from: Int(r.minY)+1, to: Int(r.maxY)-1, by: Int(step)) {
            for x in stride(from: Int(r.minX)+1, to: Int(r.maxX)-1, by: Int(step)) {
                func Y(_ dx: Int, _ dy: Int) -> Float {
                    let row = base.advanced(by: (y+dy) * bpr)
                    let p = row.advanced(by: (x+dx) * 4)
                    let b = Float(p.load(fromByteOffset: 0, as: UInt8.self)) / 255
                    let g = Float(p.load(fromByteOffset: 1, as: UInt8.self)) / 255
                    let r = Float(p.load(fromByteOffset: 2, as: UInt8.self)) / 255
                    return 0.2126*r + 0.7152*g + 0.0722*b
                }
                let gx = (-1*Y(-1,-1) + 1*Y(1,-1)) + (-2*Y(-1,0) + 2*Y(1,0)) + (-1*Y(-1,1) + 1*Y(1,1))
                let gy = (-1*Y(-1,-1) - 2*Y(0,-1) - 1*Y(1,-1)) + (1*Y(-1,1) + 2*Y(0,1) + 1*Y(1,1))
                let mag = abs(gx) + abs(gy)
                if mag > 1.2 { strongEdges += 1 }
                total += 1
            }
        }
        return total == 0 ? 0 : CGFloat(strongEdges) / CGFloat(total)
    }


    static func isSkin(r: Float, g: Float, b: Float) -> Bool {
        let rgbRule = (r > 0.25 && g > 0.12 && b > 0.08)
        let y  = 0.299*r + 0.587*g + 0.114*b
        let cb = 0.564*(b - y) + 0.5
        let cr = 0.713*(r - y) + 0.5
        let ycbcrRule = (cb > 0.05 && cb < 0.70) && (cr > 0.15 && cr < 0.80)
        let maxC = max(r, max(g, b)), minC = min(r, min(g, b))
        let delta = maxC - minC
        let s = maxC == 0 ? 0 : delta / maxC
        var h: Float = 0
        if delta > 0 {
            if maxC == r      { h = fmodf(((g - b) / delta), 6) / 6 }
            else if maxC == g { h = (((b - r) / delta) + 2) / 6 }
            else              { h = (((r - g) / delta) + 4) / 6 }
            if h < 0 { h += 1 }
        }
        let hsvRule = (h >= 0 && h <= 0.15) && (s >= 0.08 && s <= 0.70)
        return rgbRule && ycbcrRule && hsvRule
    }

    static func toHSV(_ r: Float, _ g: Float, _ b: Float) -> (Float, Float, Float) {
        let maxC = max(r, max(g, b)), minC = min(r, min(g, b))
        let v = maxC
        let d = maxC - minC
        let s = maxC == 0 ? 0 : d / maxC
        var h: Float = 0
        if d != 0 {
            if maxC == r      { h = fmodf(((g - b) / d), 6) / 6 }
            else if maxC == g { h = (((b - r) / d) + 2) / 6 }
            else              { h = (((r - g) / d) + 4) / 6 }
            if h < 0 { h += 1 }
        }
        return (h,s,v)
    }

    static func denormVisionRect(_ rect: CGRect, width: Int, height: Int) -> CGRect {
        var r = CGRect(x: rect.minX * CGFloat(width),
                       y: (1 - rect.maxY) * CGFloat(height),
                       width: rect.width * CGFloat(width),
                       height: rect.height * CGFloat(height)).integral
        r.origin.x = max(0, min(CGFloat(width-1), r.origin.x))
        r.origin.y = max(0, min(CGFloat(height-1), r.origin.y))
        r.size.width  = max(0, min(CGFloat(width) - r.origin.x, r.size.width))
        r.size.height = max(0, min(CGFloat(height) - r.origin.y, r.size.height))
        return r
    }
}
