

import SwiftUI
import SwiftData

@MainActor
final class DetailShadeViewModel: ObservableObject {
    var noteService: NotesService = DIContainer.shared.notesService
    var favoriteService: FavoriteService = DIContainer.shared.favoriteService
    
    @Published var showUnfavoriteAlert: Bool = false
    @Published var isFavorite: Bool = false
    @Published var showUnfavoriteDialog : Bool = false
    
    @Published var isEditingNotes : Bool = false
    @Published var editedNotes : String = ""
    
    @Published var recommendation: ShadeRecommendation?
    
    @Published var showCopyAlert: Bool = false
    
    func setRecommendation(recommendation: ShadeRecommendation) {
        self.recommendation = recommendation
        do {
            self.editedNotes = try noteService.getNote(note: recommendation.shade)?.note ?? ""
            isFavorite = try favoriteService.getFavorite(shadeRecommendation: recommendation) != nil
        } catch {
            print(error)
        }
    }

    var percentage: Int { recommendation?.percentage ?? 0 }
    
    var skinToneColor: Color {
        Color(hex: recommendation?.skinTone.hex ?? "")
    }
    var shadeColor: Color {
        Color(hex: recommendation?.shade.hexShade ?? "")
    }
    
    func setFavorite() {
        do {
            try favoriteService.toggleIsFavorite(shadeRecommendation: recommendation!, isFavorite: isFavorite)
        } catch {}
    }

    func toggleFavorite() {
        if isFavorite {
            showUnfavoriteAlert = true
        } else {
            isFavorite.toggle()
            setFavorite()
        }
    }

    func confirmRemoveFavorite() {
        isFavorite = false
        setFavorite()
        showUnfavoriteAlert = false
    }

    func startEditingNotes(){
        isEditingNotes = true
    }

    func savenotes(){
        recommendation?.shade.note = editedNotes
        do {
            try noteService.updateNote(note: recommendation!.shade)
        } catch {
            print(error)
        }
        isEditingNotes = false
    }


}

