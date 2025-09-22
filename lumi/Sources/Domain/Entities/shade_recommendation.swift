import SwiftUI
import SwiftData

@Model
class ShadeRecommendation {
    var id: UUID
    var shade: Shade
    var skinTone: SkinTone
    var undertone: Undertone
    var notes: String
    var lastUpdatedNote: Date
    var percentage: Int

    init(
        id: UUID,
        shade: Shade,
        skinTone: SkinTone,
        undertone: Undertone,
        notes: String = "",
        lastUpdatedNote: Date = .now,
        percentage: Int = 0
    ) {
        self.id = id
        self.shade = shade
        self.skinTone = skinTone
        self.undertone = undertone
        self.notes = notes
        self.lastUpdatedNote = lastUpdatedNote
        self.percentage = percentage
    }
}
