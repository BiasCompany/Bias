import SwiftUI
import SwiftData

final class DetailShadeViewModel: ObservableObject {
    @Published var showUnfavoriteAlert: Bool = false
    @Published var isFavorite: Bool = false
    @Published var showUnfavoriteDialog : Bool = false
    @Published var isEditingNotes : Bool = false
    @Published var editedNotes : String = ""
    let recommendation: ShadeRecommendation

    init(recommendation: ShadeRecommendation) {
        self.recommendation = recommendation
        self.editedNotes = recommendation.notes
    }


    var percentage: Int { recommendation.percentage }
    var skinToneColor: Color {
        Color(hex: recommendation.skinTone.hex)
    }
    var shadeColor: Color {
        Color(hex: recommendation.shade.hexShade)
    }


    func toggleFavorite() {
        if isFavorite {
            showUnfavoriteAlert = true
        } else {
            isFavorite.toggle()
        }
    }

    func confirmRemoveFavorite() {
        isFavorite = false
        showUnfavoriteAlert = false
    }

    func startEditingNotes(){
        isEditingNotes = true
        editedNotes = recommendation.notes

    }

    func savenotes(){
        recommendation.notes = editedNotes
        isEditingNotes = false
    }


}
