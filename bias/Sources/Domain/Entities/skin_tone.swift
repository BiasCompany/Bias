import SwiftData
import SwiftUI

@Model
class SkinTone {
    var id: UUID
    var name: String
    var hex: String
    var date: Date

    init(id: UUID, name: String, hex: String, date: Date = .now) {
        self.id = id
        self.name = name
        self.hex = hex
        self.date = date
    }
}
