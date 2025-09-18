import SwiftData
import Foundation
import SwiftUI
@Model
class Shade {
    var name: String
    var brand: Brand
    var product: String
    var description: String
    var image: String
    var undertone: Undertone
    var hexShade: String

    init(
        name: String,
        brand: Brand,
        product: String,
        description: String,
        image: String,
        undertone: Undertone,
        hexShade: String
    ) {
        self.name = name
        self.brand = brand
        self.product = product
        self.description = description
        self.image = image
        self.undertone = undertone
        self.hexShade = hexShade
    }
}
