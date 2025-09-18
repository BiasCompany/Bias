import SwiftData
import SwiftUI

@Model
class SkinTone {
    var name: String
    var hex: String
    var date: Date

    init(name: String, hex: String, date: Date = .now) {
        self.name = name
        self.hex = hex
        self.date = date
    }
}
