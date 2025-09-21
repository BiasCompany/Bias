import SwiftUI

final class NotesViewModel: ObservableObject {
    @Published var notes: [ShadeRecommendation]
    
    init(recommendations: [ShadeRecommendation]) {
        self.notes = recommendations
    }
    
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    
}
