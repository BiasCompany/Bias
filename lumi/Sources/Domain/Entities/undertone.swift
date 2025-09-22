
import SwiftUI


public enum Undertone: String, Codable {
    case cool = "cool"
    case warm = "warm"
    case neutral = "neutral"
    case unknown = "unknown"

    public init(rawOrAny raw: String?) {
        guard let r = raw?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines), !r.isEmpty else {
            self = .unknown; return
        }
        self = Undertone(rawValue: r) ?? .unknown
    }
}

enum VeinColor { case purple, blue, green, bluishGreen, unknown }
enum WhiteClothTest { case yellowish, pinkishOrBluish, neither }
enum JewelryPreference { case silver, gold, both }
enum WhiteVsCream { case pureWhite, cream, both }

struct UndertoneQuiz: Identifiable {
    let id = UUID()
    let question: String
    let description: String?
    let options: [String]
}

struct UndertoneResponses {
    var vein: VeinColor
    var whiteCloth: WhiteClothTest
    var jewelry: JewelryPreference
    var whiteVsCream: WhiteVsCream
}