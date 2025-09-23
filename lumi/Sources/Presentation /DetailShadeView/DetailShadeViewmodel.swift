

import SwiftUI
import SwiftData

@MainActor
final class DetailShadeViewModel: ObservableObject {
    @Published var showUnfavoriteAlert: Bool = false
    @Published var isFavorite: Bool = false
    @Published var showUnfavoriteDialog : Bool = false
    @Published var isEditingNotes : Bool = false
    @Published var editedNotes : String = ""
    @Published var recommendation: ShadeRecommendation?
    
    func setRecommendation(recommendation: ShadeRecommendation) {
        self.recommendation = recommendation
    }

    init() {
        self.editedNotes = recommendation?.shade.note ?? ""
    }


    var percentage: Int { recommendation?.percentage ?? 0 }
    
    var skinToneColor: Color {
        Color(hex: recommendation?.skinTone.hex ?? "")
    }
    var shadeColor: Color {
        Color(hex: recommendation?.shade.hexShade ?? "")
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
        editedNotes = recommendation?.shade.note ?? ""

    }

    func savenotes(){
        recommendation?.shade.note = editedNotes
        isEditingNotes = false
    }


}

