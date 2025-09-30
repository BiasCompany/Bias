import SwiftUI

@MainActor
final class NotesViewModel: ObservableObject {
    var service: NotesService = DIContainer.shared.notesService
    var productService: ProductService = DIContainer.shared.productService
    @Published var notes: [Note] = []
    
    func load() {
        do {
            notes = try service.getNotes()
        } catch {
            print("Error loading brands:", error)
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        return formatter.string(from: date)
    }
    
    func getDetail(note: Note) async throws -> ShadeRecommendation? {
            do {
                return try await productService.getAllShadesRecommendation().first { item in
                    item.shade.id == note.id
                }
            } catch {
                print("Error loading brands:", error)
            }
        return nil
    }
    
    
}
