
import SwiftUI

enum Undertone {
    case cool
    case neutral
    case warm
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