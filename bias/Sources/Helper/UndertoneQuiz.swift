//
//  AVFoundation-.swift
//  bias
//
//  Created by Muhammad Rifqi Syatria on 9/17/25.
//

import Foundation

let undertoneQuizzes: [UndertoneQuiz] = [
    UndertoneQuiz(
        question: "What color are your veins?",
        description: "Look at the veins at your wrist, determine its color. Preferably do it under natural light to have precise result",
        options: ["Purple", "Blue", "Green", "Bluish-green", "I don’t know"]
    ),
    UndertoneQuiz(
        question: "Next to a white cloth, how does your skin look?",
        description: "Put a plain white cloth next to your bare face in natural light, what is the result?",
        options: [
            "My skin looks yellowish",
            "My skin looks pinkish or bluish",
            "My skin looks neither too yellow or pink"
        ]
    ),
    UndertoneQuiz(
        question: "What jewelry metal looks best on you?",
        description: "When you wear jewelry, which type usually looks best on your skin?",
        options: ["Silver", "Gold", "Both Silver and Gold"]
    ),
    UndertoneQuiz(
        question: "Which color suits you more?",
        description: "When comparing pure white and cream-colored clothes against your skin (with no makeup), which one makes you look better?",
        options: ["Pure White flatters me more", "Cream flatters me more", "Both look equally good"]
    )
]

func parseVein(_ s: String) -> VeinColor {
    let t = s.lowercased()
    if t.contains("purple") { return .purple }
    if t.contains("blue") && !t.contains("green") { return .blue }
    if t.contains("green") && t.contains("blue") { return .bluishGreen }
    if t.contains("green") { return .green }
    if t.contains("don’t know") || t.contains("don't know") { return .unknown }
    return .unknown
}

func parseWhiteCloth(_ s: String) -> WhiteClothTest {
    let t = s.lowercased()
    if t.contains("yellow") { return .yellowish }
    if t.contains("pink") || t.contains("bluish") { return .pinkishOrBluish }
    if t.contains("neither") { return .neither }
    return .neither
}

func parseJewelry(_ s: String) -> JewelryPreference {
    let t = s.lowercased()
    if t.contains("silver") && t.contains("gold") { return .both }
    if t.contains("silver") { return .silver }
    if t.contains("gold") { return .gold }
    return .both
}

func parseWhiteVsCream(_ s: String) -> WhiteVsCream {
    let t = s.lowercased()
    if t.contains("pure white") { return .pureWhite }
    if t.contains("cream") { return .cream }
    if t.contains("both") { return .both }
    return .both
}