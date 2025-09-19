//
//  AllShadeRecommendationView.swift
//  bias
//
//  Created by Muhammad Rifqi Syatria on 9/17/25.
//

import SwiftUI

struct ChooseBrandView: View {
    @EnvironmentObject var vm: ChooseBrandViewModel
    @FocusState private var isSearchFocused: Bool
    @State private var isScrolled = false
    
    private let selectedBg = Color(red: 250/255, green: 248/255, blue: 246/255)

    var body: some View {
        ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders]) {
                        if vm.sections.isEmpty {
                            Text("No results found")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.top, 24)
                        }

                        ForEach(vm.sections, id: \.key) { section in
                            Section {
                                ForEach(section.values, id: \.self) { name in let isSelected = vm.selected.contains(name)
                                    HStack {
                                        Text(name)
                                            .font(.body)
                                            .foregroundStyle(.primary)
                                            .lineLimit(1)
                                            .truncationMode(.tail)
                                        Spacer()
                                        if vm.selected.contains(name) {
                                            Image(systemName: "checkmark")
                                                .font(.body.weight(.semibold))
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 56)
                                    .background(isSelected ? selectedBg : Color.white)
                                    .contentShape(Rectangle())
                                    .padding(.horizontal, 16)
                                    .onTapGesture { vm.toggleSelection(name) }

                                    Divider()
                                        .padding(.leading, 16)
                                }
                            }
                            header: {
                                ZStack(alignment: .leading) {
                                    Color(red: 0.95, green: 0.93, blue: 0.91)
                                    Text(section.key)
                                        .font(.system(size: 22, weight: .bold, design: .monospaced))
                                        .foregroundColor(.black)
                                        .padding(.horizontal, 16)
                                }
                                .frame(height: 36)
                                .id(section.key)
                            }
                        }
                    }
                    .background(Color.white)
                }
                .overlay(alignment: .trailing) {
                    AlphabetIndexBar(letters: vm.sectionTitles) { letter in
                        withAnimation(.easeInOut) { proxy.scrollTo(letter, anchor: .top) }
                    }
                    .padding(.trailing, 6)
                }
            }

                .safeAreaInset(edge: .top) {
                    HeaderView(
                        searchText: $vm.searchText,
                        isFocused: $isSearchFocused,
                        onCancel: {
                            vm.searchText = ""
                            isSearchFocused = false
                        },
                        onToggleAll: { vm.toggleSelectAll() },
                        isAllSelected: vm.isAllSelectedInCurrentView
                    )
                    
                .background(Color(red: 0.95, green: 0.93, blue: 0.91))
            }

            .safeAreaInset(edge: .bottom) {
                VStack {
                    Button {
                        // save into local
                    } label: {
                        Text("CONTINUE")
                            .font(.headline.monospaced().weight(.bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .foregroundStyle(.white)
                            .background(Color.black)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
        }
}

// MARK: - Row
private struct BrandRow: View {
    let title: String
    let isSelected: Bool

    var body: some View {
        HStack {
            Text(title)
                .foregroundStyle(.primary)
            Spacer()
            if isSelected {
                Image(systemName: "checkmark")
                    .font(.body.weight(.semibold))
            }
        }
        .padding(.vertical, 8)
    }
}

//#if DEBUG
//import SwiftUI
//
//struct ChooseBrandView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            ChooseBrandView(repo: MockProductRepository()) { selected in
//                print("Selected:", selected)
//            }
//        }
//    }
//}
//#endif
