//
//  Lab.swift
//  lumi
//
//  Created by Adithya Firmansyah Putra on 22/09/25.
//


//
//  ColorMath.swift
//  FoundationPOC
//
//  Created by Adithya Firmansyah Putra on 09/09/25.
//

import SwiftUI
import Foundation

struct Lab {
    let L: Double
    let a: Double
    let b: Double
}


enum ColorMath {
    // Parse hex like "#ABC" or "#AABBCC" (case-insensitive). Returns sRGB (0...1)
    static func hexToRGB(_ hex: String) -> (r: Double, g: Double, b: Double)? {
        var s = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if s.hasPrefix("#") { s.removeFirst() }
        let chars = Array(s.uppercased())

        func hexPair(_ c1: Character, _ c2: Character) -> Double? {
            let str = String([c1, c2])
            guard let v = UInt8(str, radix: 16) else { return nil }
            return Double(v) / 255.0
        }

        switch chars.count {
        case 3:
            // #RGB -> #RRGGBB
            guard let r = hexPair(chars[0], chars[0]),
                  let g = hexPair(chars[1], chars[1]),
                  let b = hexPair(chars[2], chars[2]) else { return nil }
            return (r,g,b)
        case 6:
            guard let r = hexPair(chars[0], chars[1]),
                  let g = hexPair(chars[2], chars[3]),
                  let b = hexPair(chars[4], chars[5]) else { return nil }
            return (r,g,b)
        default:
            return nil
        }
    }

    // sRGB gamma inverse → linear
    static func srgbToLinear(_ c: Double) -> Double {
        return (c <= 0.04045) ? (c / 12.92) : pow((c + 0.055) / 1.055, 2.4)
    }

    // sRGB (linearized) to XYZ (D65)
    static func rgbToXYZ(r: Double, g: Double, b: Double) -> (X: Double, Y: Double, Z: Double) {
        let rl = srgbToLinear(r)
        let gl = srgbToLinear(g)
        let bl = srgbToLinear(b)

        let X = rl * 0.4124564 + gl * 0.3575761 + bl * 0.1804375
        let Y = rl * 0.2126729 + gl * 0.7151522 + bl * 0.0721750
        let Z = rl * 0.0193339 + gl * 0.1191920 + bl * 0.9503041
        return (X, Y, Z)
    }

    // XYZ (D65) → CIELAB
    static func xyzToLab(X: Double, Y: Double, Z: Double) -> Lab {
        // D65 reference white
        let Xn = 0.95047
        let Yn = 1.00000
        let Zn = 1.08883
        let delta = 6.0 / 29.0

        func f(_ t: Double) -> Double {
            let cube = delta * delta * delta
            if t > cube {
                return pow(t, 1.0 / 3.0)
            } else {
                return (t / (3 * delta * delta)) + (4.0 / 29.0)
            }
        }

        let fx = f(X / Xn)
        let fy = f(Y / Yn)
        let fz = f(Z / Zn)

        let L = 116.0 * fy - 16.0
        let a = 500.0 * (fx - fy)
        let b = 200.0 * (fy - fz)
        return Lab(L: L, a: a, b: b)
    }

    static func hexToLab(_ hex: String) -> Lab? {
        guard let (r,g,b) = hexToRGB(hex) else { return nil }
        let (X, Y, Z) = rgbToXYZ(r: r, g: g, b: b)
        return xyzToLab(X: X, Y: Y, Z: Z)
    }

    // MARK: - CIEDE2000 (ΔE*00)

    private static func deg2rad(_ d: Double) -> Double { d * .pi / 180.0 }
    private static func rad2deg(_ r: Double) -> Double { r * 180.0 / .pi }

    static func ciede2000(_ lab1: Lab, _ lab2: Lab) -> Double {
        let (L1, a1, b1) = (lab1.L, lab1.a, lab1.b)
        let (L2, a2, b2) = (lab2.L, lab2.a, lab2.b)

        let kL = 1.0, kC = 1.0, kH = 1.0

        let C1 = hypot(a1, b1)
        let C2 = hypot(a2, b2)
        let Cbar = (C1 + C2) / 2.0

        let G = 0.5 * (1.0 - sqrt(pow(Cbar, 7.0) / (pow(Cbar, 7.0) + pow(25.0, 7.0))))
        let a1p = (1.0 + G) * a1
        let a2p = (1.0 + G) * a2

        let C1p = hypot(a1p, b1)
        let C2p = hypot(a2p, b2)

        var h1p = rad2deg(atan2(b1, a1p))
        var h2p = rad2deg(atan2(b2, a2p))
        if h1p < 0 { h1p += 360.0 }
        if h2p < 0 { h2p += 360.0 }

        let dLp = L2 - L1
        let dCp = C2p - C1p

        let dhp: Double = {
            if C1p * C2p == 0 { return 0.0 }
            let diff = h2p - h1p
            if abs(diff) <= 180.0 { return diff }
            return diff > 180.0 ? diff - 360.0 : diff + 360.0
        }()

        let dHp = 2.0 * sqrt(C1p * C2p) * sin(deg2rad(dhp / 2.0))
        let Lbarp = (L1 + L2) / 2.0
        let Cbarp = (C1p + C2p) / 2.0

        let hbarp: Double = {
            if C1p * C2p == 0 { return h1p + h2p }
            let diff = abs(h1p - h2p)
            if diff <= 180.0 { return (h1p + h2p) / 2.0 }
            return (h1p + h2p < 360.0) ? (h1p + h2p + 360.0) / 2.0
                                       : (h1p + h2p - 360.0) / 2.0
        }()

        let T = 1
            - 0.17 * cos(deg2rad(hbarp - 30.0))
            + 0.24 * cos(deg2rad(2.0 * hbarp))
            + 0.32 * cos(deg2rad(3.0 * hbarp + 6.0))
            - 0.20 * cos(deg2rad(4.0 * hbarp - 63.0))

        let deltaTheta = 30.0 * exp(-pow((hbarp - 275.0) / 25.0, 2.0))
        let RC = 2.0 * sqrt(pow(Cbarp, 7.0) / (pow(Cbarp, 7.0) + pow(25.0, 7.0)))
        let SL = 1.0 + (0.015 * pow(Lbarp - 50.0, 2.0)) / sqrt(20.0 + pow(Lbarp - 50.0, 2.0))
        let SC = 1.0 + 0.045 * Cbarp
        let SH = 1.0 + 0.015 * Cbarp * T
        let RT = -sin(deg2rad(2.0 * deltaTheta)) * RC

        let termL = pow(dLp / (kL * SL), 2.0)
        let termC = pow(dCp / (kC * SC), 2.0)
        let termH = pow(dHp / (kH * SH), 2.0)
        let termR = RT * (dCp / (kC * SC)) * (dHp / (kH * SH))

        return sqrt(termL + termC + termH + termR)
    }
}
