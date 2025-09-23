//
//  SkinToneCategory.swift
//  lumi
//
//  Created by Muhammad Rifqi Syatria on 9/23/25.
//


import SwiftUI

enum SkinToneCategory: String {
    case fair = "Fair / Light"
    case lightMedium = "Light-Medium"
    case medium = "Medium / Tan"
    case deep = "Deep"
    case veryDeep = "Very Deep / Dark"
}

func hexToUIColor(_ hex: String) -> UIColor {
    var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    if cString.hasPrefix("#") { cString.removeFirst() }
    if cString.count != 6 { return UIColor.gray }

    var rgbValue: UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)

    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: 1.0
    )
}

// Convert UIColor → LAB (for lightness classification)
func rgbToLab(r: CGFloat, g: CGFloat, b: CGFloat) -> (l: CGFloat, a: CGFloat, b: CGFloat) {
    func pivot(_ n: CGFloat) -> CGFloat {
        return (n > 0.008856) ? pow(n, 1/3) : (7.787 * n) + (16.0/116.0)
    }

    // Convert RGB → XYZ
    var R = r, G = g, B = b
    R = (R > 0.04045) ? pow((R + 0.055)/1.055, 2.4) : R/12.92
    G = (G > 0.04045) ? pow((G + 0.055)/1.055, 2.4) : G/12.92
    B = (B > 0.04045) ? pow((B + 0.055)/1.055, 2.4) : B/12.92

    let X = (R*0.4124 + G*0.3576 + B*0.1805) / 0.95047
    let Y = (R*0.2126 + G*0.7152 + B*0.0722) / 1.00000
    let Z = (R*0.0193 + G*0.1192 + B*0.9505) / 1.08883

    let fx = pivot(X)
    let fy = pivot(Y)
    let fz = pivot(Z)

    let L = (116 * fy) - 16
    let A = 500 * (fx - fy)
    let Bc = 200 * (fy - fz)

    return (L, A, Bc)
}

// Main classifier
func classifySkinTone(hex: String) -> SkinToneCategory {
    let color = hexToUIColor(hex)
    var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
    color.getRed(&r, green: &g, blue: &b, alpha: &a)

    let lab = rgbToLab(r: r, g: g, b: b)

    switch lab.l {
    case 75...100:
        return .fair
    case 60..<75:
        return .lightMedium
    case 45..<60:
        return .medium
    case 30..<45:
        return .deep
    default:
        return .veryDeep
    }
}
