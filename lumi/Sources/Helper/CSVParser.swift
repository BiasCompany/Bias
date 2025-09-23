//
//  CSVParser.swift
//  lumi
//
//  Created by Assistant on 9/20/25.
//

import Foundation

class CSVParser {
    static func parseAllShades() throws -> (brands: Set<String>, shades: [Shade]) {
        guard let url = Bundle.main.url(forResource: "allShades", withExtension: "csv") else {
            throw CSVParserError.fileNotFound
        }

        let content = try String(contentsOf: url, encoding: .utf8)
        let lines = content.components(separatedBy: .newlines)

        guard lines.count > 1 else {
            throw CSVParserError.emptyData
        }

        // Skip header row
        let dataLines = Array(lines.dropFirst()).filter {
            !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }

        var brands: Set<String> = []
        var shades: [Shade] = []

        for line in dataLines {
            let components = parseCSVLine(line)

            guard components.count >= 15 else { continue }  // Ensure we have enough columns

            let brand = components[1].trimmingCharacters(in: .whitespacesAndNewlines)
            let product = components[2].trimmingCharacters(in: .whitespacesAndNewlines)
            let imgSrc = components[5].trimmingCharacters(in: .whitespacesAndNewlines)
            let description = components[4].trimmingCharacters(in: .whitespacesAndNewlines)
            let name = components[7].trimmingCharacters(in: .whitespacesAndNewlines) + " " + components[8].trimmingCharacters(in: .whitespacesAndNewlines)
            let hex = components[10].trimmingCharacters(in: .whitespacesAndNewlines)
            let undertoneCategory = components[14].trimmingCharacters(in: .whitespacesAndNewlines)

            // Skip if essential fields are empty
            guard !brand.isEmpty, !name.isEmpty, !hex.isEmpty else { continue }

            brands.insert(brand)

            let undertone = Undertone(rawOrAny: undertoneCategory)
            let shade = Shade(
                id: UUID(),
                name: name,
                brand: brand,
                product: product,
                description: description,
                image: imgSrc,
                undertone: undertone,
                hexShade: hex
            )

            shades.append(shade)
        }

        return (brands: brands, shades: shades)
    }

    private static func parseCSVLine(_ line: String) -> [String] {
        var components: [String] = []
        var currentComponent = ""
        var insideQuotes = false
        var i = line.startIndex

        while i < line.endIndex {
            let char = line[i]

            if char == "\"" {
                insideQuotes.toggle()
            } else if char == "," && !insideQuotes {
                components.append(currentComponent)
                currentComponent = ""
            } else {
                currentComponent.append(char)
            }

            i = line.index(after: i)
        }

        // Add the last component
        components.append(currentComponent)

        return components
    }
}

enum CSVParserError: Error, LocalizedError {
    case fileNotFound
    case emptyData
    case parsingFailed

    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "CSV file 'allShades.csv' not found in bundle"
        case .emptyData:
            return "CSV file is empty or has no data rows"
        case .parsingFailed:
            return "Failed to parse CSV data"
        }
    }
}
