//
//  ErrorType.swift
//  mindcore
//
//  Created by Adithya Firmansyah Putra on 12/12/24.
//
import Foundation

class ErrorType: Codable, LocalizedError {
    let message: String
    let key: String?

    // Provide a custom error description
    var errorDescription: String? {
        return message
    }

    // Convenience initializer
    init(message: String, key: String? = nil) {
        self.message = message
        self.key = key
    }
}
