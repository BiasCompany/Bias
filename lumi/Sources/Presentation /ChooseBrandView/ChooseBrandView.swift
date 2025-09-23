//
//  AllShadeRecommendationView.swift
//  lumi
//
//  Created by Muhammad Rifqi Syatria on 9/17/25.
//

import SwiftUI

struct ChooseBrandView: View {
    var isEdit: Bool = false
    @EnvironmentObject var router: Router
    @EnvironmentObject var vm: ChooseBrandViewModel
    @FocusState private var isSearchFocused: Bool
    @State private var isScrolled = false

    var body: some View {
        VStack {
            if isEdit {
                BackButton()
            }
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
            .background(.white)
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
                                ForEach(section.values, id: \.self) { brand in
                                    let isSelected = vm.selectedBrands.contains(brand)
                                    BrandRow(title: brand, isSelected: isSelected)
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            isSelected ? Color("selectedCard") : Color.white
                                        )
                                        .contentShape(Rectangle())
                                        .onTapGesture { vm.toggleSelection(brand) }
                                    Divider()
                                }
                            } header: {
                                ZStack(alignment: .leading) {
                                    Color("pinedTitleCard")
                                    Text(section.key)
                                        .font(.system(size: 22, weight: .bold, design: .monospaced))
                                        .foregroundColor(.black)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 12)
                                }
                                .id(section.key)
                            }
                        }
                    }
                    .background(Color.white)
                    .padding(.horizontal, 16)
                }
                .overlay(alignment: .trailing) {
                    AlphabetIndexBar(letters: vm.sectionTitles) { letter in
                        withAnimation(.easeInOut) { proxy.scrollTo(letter, anchor: .top) }
                    }
                }
            }

            CustomButton(title: "CONTINUE") {
                Task {
                    do {
                        try await vm.saveSelection()
                        await MainActor.run {
                            if isEdit {
                                router.replaceNavigationPath(with: [.recommendation])
                            } else {
                                router.navigate(to: .chooseUndertone)
                            }
                        }
                    } catch {
                        // TODO: Surface this error to the user if needed
                        print("Failed to save selection: \(error)")
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            vm.load()
        }

    }
}

struct ChooseBrandView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseBrandView()
            .environmentObject(ChooseBrandViewModel())
    }
}
