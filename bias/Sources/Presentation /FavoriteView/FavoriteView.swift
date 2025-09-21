//
//  FavoriteView.swift
//  bias
//
//  Created by Shafa Tiara Tsabita Himawan on 21/09/25.
//

// Presentation/Views/FavoriteView.swift
import SwiftUI
import Kingfisher

struct FavoriteView: View {
    @EnvironmentObject var viewModel: FavoriteViewModel

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(viewModel.favorite) { rec in
                    FavoriteRow(rec: rec)
                        .padding(.horizontal, 20)
                }
            }
            .padding(.vertical, 16)
        }
    }
}


#Preview("History Slicing") {
    ShadeHistoryListView()
}
