import SwiftUI
import Kingfisher

struct NotesView: View {
    @EnvironmentObject var vm: NotesViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 16) {
                ForEach(vm.notes) { note in
                    HStack(alignment: .center, spacing: 20) {
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("\(note.shade.brand) - \(note.shade.product) - \(note.shade.name)")
                                .font(.caption.monospaced().bold())
                                
                            
                            Text(note.notes.isEmpty ? "No notes yet..." : note.notes)
                                .font(.caption2.monospaced())
                                .foregroundColor(note.notes.isEmpty ? .gray : .primary)
                                .lineLimit(2)
                            
                            Text(vm.formattedDate(note.lastUpdatedNote))
                                .font(.system(.caption2))
                                .italic()
                                .foregroundColor(Color(ColorResource.greyText))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        KFImage(URL(string: note.shade.image))
                            .placeholder { ProgressView() }
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .background {
                                Rectangle().foregroundColor(Color(ColorResource.bg))
                            }
                            
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.black)
                            .font(.system(.caption2))
                        
                    }
                    
                    .padding(.horizontal, 16)
                }
            }
            .padding(.vertical, 20)
        }
        
    }
}

#Preview {
    let shade1 = Shade(
        id: UUID(),
        name: "120C",
        brand: "WARDAH",
        product: "All Hour Foundation",
        description: "Medium neutral tone foundation",
        image: "https://images.ulta.com/is/image/Ulta/2551437sw?$tn$",
        undertone: Undertone(rawValue: "cool") ?? .neutral,
        hexShade: "#D7A377"
    )
    
    let shade2 = Shade(
        id: UUID(),
        name: "220W",
        brand: "Maybelline",
        product: "Fit Me Foundation",
        description: "Warm undertone shade",
        image: "https://images.ulta.com/is/image/Ulta/2300153sw?$tn$",
        undertone: Undertone(rawValue: "warm") ?? .neutral,
        hexShade: "#E1B899"
    )
    
    let skinTone = SkinTone(id: UUID(), name: "Medium", hex: "#EFBF96")
    
    let recommendations = [
        ShadeRecommendation(id: UUID(), shade: shade1, skinTone: skinTone, undertone: .neutral, notes: "Ini product oke sih, shade nya oke, texture nya juga okay, ga gampang oksidasi, udah punya juga kok", percentage: 85),
        ShadeRecommendation(id: UUID(), shade: shade2, skinTone: skinTone, undertone: .warm, notes: "Agak terlalu warm untukku, tapi masih masuk.", percentage: 70),
        ShadeRecommendation(id: UUID(), shade: shade1, skinTone: skinTone, undertone: .cool, notes: "bagus banget inininiinisanksnaksaks", percentage: 60),
        ShadeRecommendation(id: UUID(), shade: shade1, skinTone: skinTone, undertone: .neutral, notes: "Ini product oke sih, shade nya oke, texture nya juga okay, ga gampang oksidasi, udah punya juga kok", percentage: 85),
        ShadeRecommendation(id: UUID(), shade: shade2, skinTone: skinTone, undertone: .warm, notes: "Agak terlalu warm untukku, tapi masih masuk.", percentage: 70),
        ShadeRecommendation(id: UUID(), shade: shade1, skinTone: skinTone, undertone: .cool, notes: "bagus banget inininiinisanksnaksaks", percentage: 60),
        
    ]
    
    let vm = NotesViewModel(recommendations: recommendations)
    NotesView()
        .environmentObject(vm)
}
