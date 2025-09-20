import Combine
import SwiftUI

final class ChooseUndertoneViewModel: ObservableObject {

    enum Undertone: String, CaseIterable, Hashable, Identifiable {
        case cool, neutral, warm
        var id: String { rawValue }

        var label: String {
            switch self {
            case .cool: return "COOL"
            case .neutral: return "NEUTRAL"
            case .warm: return "WARM"
            }
        }

        var subtitle: String {
            switch self {
            case .cool:
                return "Your veins color is purple or blue"
            case .neutral:
                return "Your veins color is green and blue"
            case .warm:
                return "Your veins color is green or olive"
            }
        }

        var assetName: String {
            switch self {
            case .cool: return "cool"
            case .neutral: return "neutral"
            case .warm: return "warm"
            }
        }
    }

    // MARK: - Published state
    @Published var selected: Undertone? = nil

    // MARK: - Copy
    let infoText =
        "Check your wrist veins to determine your undertone, preferably under natural light for precise result."

    // MARK: - Intent
    func select(_ u: Undertone) {
        selected = u
    }

    func startAutoAnalysis() {

    }

    @Published var currentStep: Int = 0
    @Published var answers: [String]
    @Published var showResult: Bool = false
    @Published private(set) var result: String = ""

    private let resultImage: [String: String] = [
        "Cool": "Cool",
        "Warm": "Warm",
        "Netral": "Netral",
    ]

    private let resultDescription: [String: String] = [
        "Cool": "With cool undertones, your skin has pink, red, and bluish hues.",
        "Warm": "With warm undertones, your skin has peachy, golden, or yellow hues.",
        "Netral":
            "With Netral undertones, warm and cool tones balance, revealing your skin’s natural shade.",
    ]

    let questions: [QuizQuestion] = [
        QuizQuestion(
            id: 1,
            title: "WHAT COLOR\nARE YOUR VEINS?",
            tip:
                "Look at the veins at your wrist, determine it’s color. Preferably do it under natural light to have precise result",
            options: ["Purple", "Blue", "Green", "Bluish-green", "I don’t know"]
        ),
        QuizQuestion(
            id: 2,
            title: "NEXT TO A WHITE CLOTH,\nHOW DOES YOUR SKIN LOOK?",
            tip:
                "Put a plain white cloth next to your bare face in natural light, what is the result?",
            options: [
                "My skin looks yellowish", "My skin looks pinkish or bluish",
                "My skin looks neither too yellow or pink",
            ]
        ),
        QuizQuestion(
            id: 3,
            title: "WHAT JEWELRY METAL\nLOOKS BEST ON YOU?",
            tip: "When you wear jewelry, which type usually looks best on your skin?",
            options: ["Silver", "Gold", "Both"]
        ),
        QuizQuestion(
            id: 4,
            title: "WHICH COLOR SUITS YOU MORE?",
            tip:
                "When comparing pure white and cream-colored clothes against your skin (with no makeup), which one makes you look better?",
            options: [
                "Pure White flatters me more", "Cream flatters me more", "Both look equally good",
            ]
        ),
    ]

    init() {
        self.answers = Array(repeating: "", count: questions.count)
    }

    func selectAnswer(_ option: String) {
        answers[currentStep] = option
    }

    func nextStep() {
        if currentStep < questions.count - 1 {
            currentStep += 1
        } else {
            calculateResult()
        }
    }

    private func calculateResult() {
        let q1 = answers[0]
        let q2 = answers[1]
        let q3 = answers[2]
        let q4 = answers[3]

        var score = ["cool": 0, "warm": 0, "Netral": 0]

        if ["Purple", "Blue"].contains(q1) {
            score["cool", default: 0] += 1
        } else if q1 == "Green" {
            score["warm", default: 0] += 1
        } else if q1 == "Bluish-green" || q1 == "I don’t know" {
            score["Netral", default: 0] += 1
        }

        if q2 == "My skin looks yellowish" {
            score["warm", default: 0] += 1
        } else if q2 == "My skin looks pinkish or bluish" {
            score["cool", default: 0] += 1
        } else if q2 == "My skin looks neither too yellow or pink" {
            score["Netral", default: 0] += 1
        }

        if q3 == "Silver" {
            score["cool", default: 0] += 1
        } else if q3 == "Gold" {
            score["warm", default: 0] += 1
        } else if q3 == "Both" {
            score["Netral", default: 0] += 1
        }

        if q4 == "Pure White flatters me more" {
            score["cool", default: 0] += 1
        } else if q4 == "Cream flatters me more" {
            score["warm", default: 0] += 1
        } else if q4 == "Both look equally good" {
            score["Netral", default: 0] += 1
        }

        if score["cool"]! > score["warm"]! && score["cool"]! >= score["Netral"]! {
            result = "Cool"
        } else if score["warm"]! > score["cool"]! && score["warm"]! >= score["Netral"]! {
            result = "Warm"
        } else {
            result = "Netral"
        }

        showResult = true
    }

    var undertoneImage: String? {
        resultImage[result]
    }

    var undertoneDescription: String? {
        resultDescription[result]
    }
}
