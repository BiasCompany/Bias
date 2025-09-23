import SwiftUI
import SwiftData

@Model
class ShadeRecommendation {
    var id: UUID
    var shade: Shade
    var skinTone: SkinTone
    var undertone: Undertone
    var percentage: Int

    init(
        id: UUID,
        shade: Shade,
        skinTone: SkinTone,
        undertone: Undertone,
        percentage: Int = 0
    ) {
        self.id = id
        self.shade = shade
        self.skinTone = skinTone
        self.undertone = undertone
        self.percentage = percentage
    }
    
    var skinToneColor : Color {
        Color(hex: skinTone.hex)
    }
    
    var shadeColor: Color {
        Color(hex: shade.hexShade)
    }
}
