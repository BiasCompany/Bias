import SwiftUI
import Kingfisher

struct ShadeRecommendationView: View {
    @EnvironmentObject var router: Router
    @EnvironmentObject var viewModel: ShadeRecommendationViewModel
    @EnvironmentObject var notesVM: NotesViewModel
    @EnvironmentObject var favoriteVM: FavoriteViewModel
    @State private var segment: MySegment = .brands
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.black)
                    .frame(width: 30, height: 30)
                    .padding(.top, 16)
                    .onTapGesture {
                        router.navigate(to: .skinAnalysis)
                    }
            }
            
            CustomSegmentedControl(selectedSegment: $segment)
            
            switch segment {
                case .brands: BrandView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .favorites: FavoriteView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .notes: NotesView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
        }
        .padding(.horizontal, 16)
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.load()
            favoriteVM.load()
            notesVM.load()
        }
    }
}


#Preview {
    ShadeRecommendationView()
        .environmentObject(ShadeRecommendationViewModel())
        .environmentObject(Router())
}
