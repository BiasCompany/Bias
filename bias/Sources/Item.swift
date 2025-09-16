//
//  Item.swift
//  bias
//
//  Created by Muhammad Rifqi Syatria on 9/16/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
