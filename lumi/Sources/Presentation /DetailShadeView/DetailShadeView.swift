import SwiftUI
import Kingfisher

struct DetailShadeView: View {
    let shadeRecommendation: ShadeRecommendation
    @EnvironmentObject var viewModel: DetailShadeViewModel
    
    var body: some View {
        if viewModel.recommendation == nil {
            VStack {
                BackButton()
                Text("Not Found")
                Spacer()
            }
            .onAppear {
                viewModel.setRecommendation(recommendation: shadeRecommendation)
            }
            .navigationBarBackButtonHidden()
        } else {
            VStack {
                HStack {
                    BackButton()
                    Spacer()
                    Button {
                        if viewModel.isFavorite {
                            viewModel.showUnfavoriteAlert = true
                        } else {
                            viewModel.toggleFavorite()
                        }
                    } label: {
                        Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(viewModel.isFavorite ? .red : .black)
                    }
                    .padding(.horizontal, 16)
                    
                    .confirmationDialog(
                        "Remove Favorite?",
                        isPresented: $viewModel.showUnfavoriteAlert,
                        titleVisibility: .visible
                    ) {
                        Button("Remove", role: .destructive) {
                            viewModel.confirmRemoveFavorite()
                        }
                        Button("Cancel", role: .cancel) { }
                    } message: {
                        Text("If your skin tone changes, you might not be able to add this product again after deleting it.")
                    }
                }
                KFImage(URL(string: viewModel.recommendation!.shade.image))
                    .placeholder { ProgressView() }
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: 289)
                    .padding()
                
                
                HStack(spacing: 0) {
                    Text(viewModel.recommendation!.skinTone.name)
                        .frame(maxWidth: .infinity)
                        .layoutPriority(3)
                        .padding(.vertical, 18)
                        .background(viewModel.skinToneColor)
                    
                    Text(viewModel.recommendation!.shade.name)
                        .frame(maxWidth: .infinity)
                        .layoutPriority(3)
                        .padding(.vertical, 18)
                        .background(viewModel.shadeColor)
                }
                .frame(maxWidth: .infinity)
                .font(.system(size: 8))
                .fontWeight(.light)
                
                VStack(alignment:.leading) {
                    Text("\(viewModel.recommendation!.percentage)% Match to your shade")
                        .font(.system(size: 12))
                        .fontWeight(.light)
                   
                    VStack(alignment: .leading, spacing: 8){
                        Text(viewModel.recommendation!.shade.brand)
                            .font(.system(size: 12))
                            .fontWeight(.semibold)
                        HStack{
                            Text(viewModel.recommendation!.shade.product)
                                .font(.system(size: 20))
                                .fontWeight(.semibold)
                            Image(systemName: "document.on.document")
                                .contextMenu {
                                    Button{
                                        UIPasteboard.general.string = viewModel.recommendation!.shade.product
                                    } label: {
                                        Image(systemName: "document.on.document")
                                    }
                                    }
                        }
                        Text(viewModel.recommendation!.shade.name)
                            .font(.system(size: 20))
                            .fontWeight(.light)
                        
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 24)
                    
                    HStack{
                        Text("Notes")
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                        Spacer()
                        Button{
                            viewModel.isEditingNotes = true
                        }label: {
                            Image(systemName: "square.and.pencil")
                        }
                        .foregroundColor(.black)
                    }
                    .padding(.bottom, 8)
                    if viewModel.isEditingNotes {
                        TextField("Enter your notes here...", text: $viewModel.editedNotes, axis: .vertical)
                            
                            .foregroundStyle(.black)
                            
                    }else {
                        Text(viewModel.recommendation!.shade.note.isEmpty ? "No Notes for this product..." : viewModel.recommendation!.shade.note  )
                            .foregroundColor(viewModel.recommendation!.shade.note .isEmpty ? .gray : .black)
                    }
                    
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                
                Spacer()
            }
            .onAppear {
                viewModel.setRecommendation(recommendation: shadeRecommendation)
            }
            .navigationBarBackButtonHidden()
        }
        
       
    }
}


//#Preview {
//    let vm = DetailShadeViewModel()
//    
//    DetailShadeView()
//        .environmentObject(vm)
//        
//}

