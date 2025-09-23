import SwiftUI
import Kingfisher

struct ShadeRecommendationView: View {
    @EnvironmentObject var viewModel: ShadeRecommendationViewModel
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
    }
}


#Preview {
    ShadeRecommendationView()
        .environmentObject(ShadeRecommendationViewModel())
        .environmentObject(Router())
}
