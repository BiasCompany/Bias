import SwiftData
import Foundation
import SwiftUI
@Model
class Shade {
    var id: UUID
    var name: String
    var brand: Brand
    var product: String
    var descriptionShade: String
    var image: String
    var undertone: Undertone
    var hexShade: String
    var note: String
    var lastUpdateNote: Date

    init(
        id: UUID,
        name: String,
        brand: Brand,
        product: String,
        description: String,
        image: String,
        undertone: Undertone,
        hexShade: String,
        note: String = "",
        lastUpdatedNote: Date = .now
    ) {
        self.id = id
        self.name = name
        self.brand = brand
        self.product = product
        self.descriptionShade = description
        self.image = image
        self.undertone = undertone
        self.hexShade = hexShade
        self.note = note
        self.lastUpdateNote = lastUpdatedNote
    }
}
