import SwiftUI

struct OnBoardingView: View {
    @EnvironmentObject private var router: Router
    @State private var currentPage: Int = 0
    @State private var showButton: Bool = false
    @State private var animationProgress: Double = 0.0
    @State private var animationTimer: Timer?
    @State private var pageProgress: [Double] = [0.0, 0.0, 0.0]  // Progress for each page

    private func startProgressAnimation() {
        // Stop any existing timer first
        animationTimer?.invalidate()
        animationTimer = nil

        let pageAtStart = currentPage
        pageProgress[pageAtStart] = 0.0
        let startTime = Date()

        // Use a timer on the .common run loop so it keeps firing during UI interactions
        let timer = Timer(timeInterval: 0.016, repeats: true) { t in
            // If the user navigated away, stop this timer
            if currentPage != pageAtStart {
                t.invalidate()
                animationTimer = nil
                return
            }

            let elapsed = Date().timeIntervalSince(startTime)
            let progress = min(elapsed / 3.0, 1.0)  // 3s duration
            pageProgress[pageAtStart] = progress * 3.0

            if progress >= 1.0 {
                t.invalidate()
                animationTimer = nil

                // Only advance if we’re still on the same page we started on
                if currentPage == pageAtStart {
                    if currentPage < 2 {
                        showButton = false
                        // NOTE: do NOT wrap in withAnimation
                        currentPage += 1
                    } else {
                        showButton = true
                    }
                }
            }
        }

        RunLoop.main.add(timer, forMode: .common)
        animationTimer = timer
    }

    private func stopProgressAnimation() {
        animationTimer?.invalidate()
        animationTimer = nil
    }

    private func resetAllState() {
        // Stop any running animation
        stopProgressAnimation()

        // Reset all state variables
        currentPage = 0
        showButton = false
        animationProgress = 0.0
        pageProgress = [0.0, 0.0, 0.0]
    }
    
    private func goToPreviousPage() {
        stopProgressAnimation()
            if currentPage == 2 && showButton {
                showButton = false
                currentPage = 2
                startProgressAnimation()
            } else if currentPage > 0 {
                currentPage -= 1
            }
    }


    private func goToNextPage() {
        stopProgressAnimation()
            if currentPage < 2 {
                currentPage += 1
            } else {
                showButton = true
            }
    }

    var body: some View {
        VStack {

            ZStack {
                TabView(selection: $currentPage) {

                    ZStack {
                        Image("onboard_one")
                            .resizable()
                            .scaledToFill()
                            .frame(maxHeight: .infinity)

                        VStack {
                            Spacer()
                                .frame(height: 600)
                            Text("DISCOVER YOUR SKIN'S TRUE SHADE")
                                .font(
                                    .system(
                                        size: 32,
                                        weight: .semibold,
                                        design: .monospaced
                                    )
                                )
                                .padding(.horizontal, 32)
                                .padding(.bottom, 8)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("Let the camera unveil your skin tone.")
                                .font(.caption.weight(.regular))
                                .padding(.horizontal, 32)
                                .frame(maxWidth: .infinity, alignment: .leading)

                        }

                    }.tag(0)
                    ZStack {
                        Image("onboard_two")
                            .resizable()
                            .scaledToFill()
                            .frame(maxHeight: .infinity)
                        VStack {
                            Spacer()
                                .frame(height: 580)
                            Text("FIND THE SHADE MATCH FOR YOU")
                                .font(
                                    .system(
                                        size: 32,
                                        weight: .semibold,
                                        design: .monospaced
                                    )
                                )
                                .padding(.horizontal, 32)
                                .padding(.bottom, 8)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(
                                "Experience the ease of finding a foundation crafted just for your skin."
                            )
                            .font(.caption.weight(.regular))
                            .padding(.horizontal, 32)
                            .multilineTextAlignment(.leading)

                            .frame(maxWidth: .infinity, alignment: .leading)

                        }
                    }.tag(1)
                    ZStack {
                        Image("onboard_three")
                            .resizable()
                            .scaledToFill()
                            .frame(maxHeight: .infinity)
                        VStack {
                            Spacer()
                                .frame(height: 580)
                            Text("READY TO MAKE A MATCH?")

                                .font(.system(size: 32, weight: .semibold, design: .monospaced))
                                .padding(.horizontal, 32)
                                .padding(.bottom, 8)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("We'll help you to uncover your true beauty.")
                                .font(.caption.weight(.regular))
                                .padding(.horizontal, 32)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.bottom, 16)

                    }.tag(2)

                }
                .ignoresSafeArea()
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

                // Transparent tap areas for navigation - overlaid on top
                HStack(spacing: 0) {
                    // Left tap area (previous page)
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: UIScreen.main.bounds.width / 2)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            goToPreviousPage()
                        }

                    // Right tap area (next page)
                    Rectangle()
                        .fill(Color.clear)
                        .frame(width: UIScreen.main.bounds.width / 2)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            goToNextPage()
                        }
                }
                .allowsHitTesting(true)
                .clipped()
            }

            if showButton {

                HStack(spacing: 12) {
                    CustomButton(
                        title: "arrow.left",
                        action: {
                            withAnimation {
                                goToPreviousPage()
                            }
                        }, isDense: true, isFilled: true, isIconOnly: true, iconName: "star"
                    )

                    CustomButton(
                        title: "LET'S GET STARTED",
                        action: {
                            router.navigate(to: .brandPreference(isEdit: false))
                        }, isFilled: true
                    )
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .transition(.opacity)

            } else {
                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { index in
                        ProgressView(value: pageProgress[index], total: 3.0)
                            .progressViewStyle(.linear)
                            .frame(height: 4)
                            .clipShape(Rectangle())
                            .frame(maxWidth: index == currentPage ? .infinity : 20)
                            .tint(.black)
                            .animation(.easeInOut(duration: 0.3), value: pageProgress[index])
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding()
                .padding(.horizontal, 20)
            }

        }
        .navigationBarBackButtonHidden()
        .onAppear {
            DispatchQueue.main.async {
                resetAllState()
                startProgressAnimation()
            }
        }
        .onChange(of: currentPage) { prevPage, newPage in
            print("Page changed to: \(newPage)")  // Debug print

            // Only mark pages as completed when going forward (not backward)
            if newPage > prevPage {
                // Mark all previous pages as completed (3.0) when skipping forward
                withAnimation(.easeInOut(duration: 0.3)) {
                    for i in 0..<newPage {
                        pageProgress[i] = 3.0
                    }
                }
            } else if newPage < prevPage {
                // When going backward, reset all pages after current page to 0
                withAnimation(.easeInOut(duration: 0.3)) {
                    for i in (newPage + 1)..<3 {
                        pageProgress[i] = 0.0
                    }
                }
            }

            startProgressAnimation()
        }
    }

}

#Preview {
    OnBoardingView()
}
