import Kingfisher
import SwiftUI

struct NotesView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var vm: NotesViewModel
    
    var body: some View {
        
        if vm.notes.isEmpty{
            EmptyNotesView()
                .onAppear {
                    vm.load()
                }
        } else {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(vm.notes, id: \.id) { shade in
                        HStack(alignment: .center, spacing: 20) {
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("\(shade.brand) - \(shade.product) - \(shade.name)")
                                    .font(.caption.monospaced().bold())
                                    
                                
                                Text(shade.note.isEmpty ? "No notes yet..." : shade.note)
                                    .font(.caption2.monospaced())
                                    .foregroundColor(shade.note.isEmpty ? .gray : .primary)
                                    .lineLimit(2)
                                
                                Text(vm.formattedDate(shade.lastUpdateNote))
                                    .font(.system(.caption2))
                                    .italic()
                                    .foregroundColor(Color(ColorResource.greyText))
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            KFImage(URL(string: shade.image))
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
                        .onTapGesture {
                            Task {
                                let shadeRecommendation = try await vm.getDetail(note: shade)
                                if shadeRecommendation != nil {
                                    router.navigate(to: .detailShade(shadeRecommendation: shadeRecommendation!))
                                }
                            }
                        }
                    }
                }
                .padding(.vertical, 20)
            }
            .onAppear {
                vm.load()
            }
        }
        
    }
}
//
//#Preview {
//    // Mock data for preview
//    let shade1 = Shade(
//        id: UUID(),
//        name: "120C",
//        brand: "WARDAH",
//        product: "All Hour Foundation",
//        description: "Medium neutral tone foundation",
//        image: "https://images.ulta.com/is/image/Ulta/2551437sw?$tn$",
//        undertone: Undertone(rawValue: "cool") ?? .neutral,
//        hexShade: "#D7A377"
//    )
//
//    let shade2 = Shade(
//        id: UUID(),
//        name: "220W",
//        brand: "Maybelline",
//        product: "Fit Me Foundation",
//        description: "Warm undertone shade",
//        image: "https://images.ulta.com/is/image/Ulta/2300153sw?$tn$",
//        undertone: Undertone(rawValue: "warm") ?? .neutral,
//        hexShade: "#E1B899"
//    )
//
//    struct Note: Identifiable {
//        let id: UUID
//        let shade: Shade
//        let notes: String
//        let lastUpdatedNote: Date
//    }
//
//    final class NotesViewModel: ObservableObject {
//        @Published var notes: [Note] = []
//        func formattedDate(_ date: Date) -> String { 
//            let f = DateFormatter()
//            f.dateStyle = .medium
//            f.timeStyle = .short
//            return f.string(from: date)
//        }
//    }
//
//    let vm = NotesViewModel()
//    vm.notes = [
//        Note(id: UUID(), shade: shade1, notes: "Great coverage, lasts long.", lastUpdatedNote: Date()),
//        Note(id: UUID(), shade: shade2, notes: "Too warm for winter.", lastUpdatedNote: Date())
//    ]
//
//    return NotesView()
//        .environmentObject(vm)
//}

