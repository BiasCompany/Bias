import SwiftUI

@MainActor
final class NotesViewModel: ObservableObject {
    @Published var notes: [Shade]
    
    init() {
        self.notes = [
            .dummy
        ]
    }
    
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    
}
