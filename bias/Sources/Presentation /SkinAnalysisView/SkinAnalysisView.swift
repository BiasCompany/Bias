//
//  SkinAnalysisView.swift
//  bias
//
//  Created by Nuraiza Hafida on 21/09/25.
//
import SwiftUI

// MARK: - Segmented
enum AnalysisTab: String, CaseIterable, Identifiable {
    case skinTone = "SKIN TONE"
    case undertone = "UNDERTONE"
    var id: String { rawValue }
}

struct PillSegmentedControl: View {
    @Binding var selection: AnalysisTab

    var body: some View {
        HStack(spacing: 0) {
            segment(.skinTone)
            segment(.undertone)
        }
        .padding(4)
        .background(RoundedRectangle(cornerRadius: 0).fill(Color("creamLabel")))
        .clipShape(RoundedRectangle(cornerRadius: 0))
    }

    @ViewBuilder
    private func segment(_ tab: AnalysisTab) -> some View {
        let isOn = selection == tab
        Button {
            selection = tab
        } label: {
            Text(tab.rawValue)
                .font(
                    .system(
                        size: 12,
                        weight: .semibold,
                        design: .monospaced
                    )
                )
                .kerning(0)
                .foregroundStyle(.black)
                .frame(
                    maxWidth: .infinity,
                    minHeight: 28
                )
                .background(
                    Rectangle()
                        .fill(isOn ? .white : .clear)
                )
        }
        .buttonStyle(.plain)
        .shadow(
            color: .black.opacity(isOn ? 0.12 : 0),
            radius: 3,
            y: 2
        )
    }
}

// MARK: - Screen
struct SkinAnalysisView: View {
    // Data contoh — ganti dari modelmu nanti
    @State private var selectedTab: AnalysisTab = .skinTone
    @State private var skinTone: String = "Medium"
    @State private var undertone: String = "Neutral"
    @State private var lastUpdate: String = "12 August 2025"

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .center, spacing: 40) {

                    // Title
                    Text("YOUR SKIN ANALYSIS")
                        .font(.system(size: 22, weight: .bold, design: .monospaced))
                        .kerning(0)
                        .frame(maxWidth: 360, alignment: .center)
                        .foregroundStyle(.black)

                    // Subtitle
                    Text("You have \(skinTone) Skin Tone\nwith \(undertone) Undertone")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 16))
                        .foregroundStyle(.black.opacity(0.9))
                        .frame(maxWidth: 360)

                    // Segmented
                    PillSegmentedControl(selection: $selectedTab)
                        .frame(maxWidth: 360)

                    // Card (hasil)
                    VStack(alignment: .leading, spacing: 28) {
                        HStack {
                            Text(selectedTab == .skinTone ? "YOUR SKIN TONE" : "YOUR UNDERTONE")
                                .font(.system(size: 16, weight: .semibold, design: .monospaced))
                                .kerning(0)
                            Spacer()
                            Button("Recheck") {
                                // action untuk re-scan / re-quiz
                            }
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(.black)
                        }

                        // Swatch warna / label hasil
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(selectedTab == .skinTone ? Color("creamMedium") : Color("creamLabel"))
                                .frame(maxWidth: 393, minHeight: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 0))

                            Text(selectedTab == .skinTone ? skinTone.uppercased() : undertone.uppercased())
                                .font(.system(size: 22, weight: .bold, design: .monospaced))
                                .kerning(0)
                                .foregroundStyle(.black)
                                .padding(.horizontal, 16)
                        }

                        // Last update
                        Text("Last update: \(lastUpdate)")
                            .font(.system(size: 12, weight: .regular))
                            .italic()
                            .foregroundStyle(.gray)

                        // Disclaimer
                        VStack(alignment: .leading, spacing: 12) {
                            Text("These results are designed to give you valuable guidance and should not be taken as a replacement for professional advice, diagnosis, or treatment.")
                            Text("For a truly personalized recommendation, we suggest consulting with a licensed skincare specialist.")
                        }
                        .font(.system(size: 12))
                        .foregroundStyle(.black.opacity(0.9))

                        Spacer(minLength: 0)

                        // Link tutorial
                        Button {
                            // open tutorial
                        } label: {
                            Text("See tutorial here")
                                .underline()
                                .font(.system(size: 12, weight: .regular))
                                .foregroundStyle(.black)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                        
                        // Save button
                        Button {
                            // simpan perubahan
                        } label: {
                            Text("SAVE CHANGES")
                                .font(.system(size: 16, weight: .semibold, design: .monospaced))
                                .kerning(0)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity, minHeight: 48)
                                .background(.black)
                                .clipShape(RoundedRectangle(cornerRadius: 0))
                        }
                        .padding(.top, 0)
                        .padding(.horizontal, 0)
                        .padding(.bottom, 20)
                    }
                    .padding(24)
                    .background(Rectangle()
                        .fill(Color("creamLabel")))

                  
                }
               
            }
            
            .frame(maxWidth: .infinity, alignment: .center)
            .background(Color.white.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    // Back icon hitam seperti di mock
                    Button(action: {}) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.black)
                    }
                }
            }
        }
    }
}

#Preview {
    SkinAnalysisView()
}
