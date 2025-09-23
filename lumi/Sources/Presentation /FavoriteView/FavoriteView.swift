//
//  FavoriteView.swift
//  lumi
//
//  Created by Shafa Tiara Tsabita Himawan on 21/09/25.
//

import Kingfisher
// Presentation/Views/FavoriteView.swift
import SwiftUI

struct FavoriteView: View {
    @EnvironmentObject var viewModel: FavoriteViewModel

    var body: some View {
        if viewModel.isLoading {
            ProgressView("Loading favorites…")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onAppear {
                    viewModel.load()
                }
        } else if viewModel.favorites.isEmpty {
            FavoriteEmptyStateView()
        } else {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(viewModel.favorites) { rec in
                        FavoriteRow(rec: rec)
                            .padding(.horizontal, 20)
                    }
                }
                .padding(.vertical, 16)
            }
        }
    }
}

//#Preview("History Slicing") {
//    ShadeHistoryListView()
//}
