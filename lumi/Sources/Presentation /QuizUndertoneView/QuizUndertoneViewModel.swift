import Combine
import SwiftUI

@MainActor
final class QuizUndertoneViewModel: ObservableObject {
    @Published var currentStep: Int = 0
    @Published var answers: [String]
    @Published var showResult: Bool = false
    @Published private(set) var result: Undertone = .unknown
    @Published private(set) var isLoading: Bool = false
    @Published var skinAnalysisService: SkinAnalysisService
    
    init() {
        skinAnalysisService = DIContainer.shared.skinAnalysisService
        self.answers = Array(repeating: "", count: questions.count)
    }
 
    func resetState() {
        currentStep = 0
        answers = []
        showResult = false
        self.answers = Array(repeating: "", count: questions.count)
    }
    
    func saveUndertone() {
        Task {
            await MainActor.run {
                isLoading = true
            }
            
            do {
                try await skinAnalysisService.saveUndertone(result)
                
                await MainActor.run {
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                }
            }
        }
    }

    private let resultImage: [Undertone: String] = [
        .cool: "cool",
        .warm: "warm",
        .neutral: "neutral",
    ]

    private let resultDescription: [Undertone: String] = [
        .cool: "With cool undertones, your skin has pink, red, and bluish hues.",
        .warm: "With warm undertones, your skin has peachy, golden, or yellow hues.",
        .neutral:
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
    
    func prevStep() {
        if currentStep > 0 {
            currentStep -= 1
        }
    }

    private func calculateResult() {
        let q1 = answers[0]
        let q2 = answers[1]
        let q3 = answers[2]
        let q4 = answers[3]

        var score = [Undertone.cool: 0, Undertone.warm: 0, Undertone.neutral: 0]

        if ["Purple", "Blue"].contains(q1) {
            score[Undertone.cool, default: 0] += 1
        } else if q1 == "Green" {
            score[Undertone.warm, default: 0] += 1
        } else if q1 == "Bluish-green" || q1 == "I don’t know" {
            score[Undertone.neutral, default: 0] += 1
        }

        if q2 == "My skin looks yellowish" {
            score[Undertone.warm, default: 0] += 1
        } else if q2 == "My skin looks pinkish or bluish" {
            score[Undertone.cool, default: 0] += 1
        } else if q2 == "My skin looks neither too yellow or pink" {
            score[Undertone.neutral, default: 0] += 1
        }

        if q3 == "Silver" {
            score[Undertone.cool, default: 0] += 1
        } else if q3 == "Gold" {
            score[Undertone.warm, default: 0] += 1
        } else if q3 == "Both" {
            score[Undertone.neutral, default: 0] += 1
        }

        if q4 == "Pure White flatters me more" {
            score[Undertone.cool, default: 0] += 1
        } else if q4 == "Cream flatters me more" {
            score[Undertone.warm, default: 0] += 1
        } else if q4 == "Both look equally good" {
            score[Undertone.neutral, default: 0] += 1
        }

        if score[Undertone.cool]! > score[Undertone.warm]! && score[Undertone.cool]! >= score[Undertone.neutral]! {
            result = Undertone.cool
        } else if score[Undertone.warm]! > score[Undertone.cool]! && score[Undertone.warm]! >= score[Undertone.neutral]! {
            result = Undertone.warm
        } else {
            result = Undertone.neutral
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
