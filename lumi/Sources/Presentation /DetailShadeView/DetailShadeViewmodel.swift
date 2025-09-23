

import SwiftUI
import SwiftData

@MainActor
final class DetailShadeViewModel: ObservableObject {
    @Published var showUnfavoriteAlert: Bool = false
    @Published var isFavorite: Bool = false
    @Published var showUnfavoriteDialog : Bool = false
    @Published var isEditingNotes : Bool = false
    @Published var editedNotes : String = ""
    let recommendation: ShadeRecommendation = ShadeRecommendation(
        id: UUID(),
        shade: Shade(
            id: UUID(),
            name: "120 C (Neutral Undertone)",
            brand: "YSL",
            product: "Foundation",
            description: "Test description",
            image: "https://images.ulta.com/is/image/Ulta/2551437sw?$tn$",
            undertone: .neutral,
            hexShade: "#D7A377",
            note: "Test note",
        ),
        skinTone: SkinTone(id: UUID(), name: "Medium", hex: "#EFBF96"),
        undertone: .neutral,
        percentage: 85
    )

    init() {
        self.editedNotes = recommendation.shade.note
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
        editedNotes = recommendation.shade.note

    }

    func savenotes(){
        recommendation.shade.note = editedNotes
        isEditingNotes = false
    }


}

