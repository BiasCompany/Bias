import SwiftUI

import SwiftUI


struct OnBoardingView : View {
    @State private var currentPage : Int = 0
    // MARK: - Bottom Section
    var bottomSection: some View {
        GeometryReader { geometry in
            let width = geometry.size.width - 32
            VStack(spacing: 0) {
                if currentPage < 2 {
                    HStack(spacing: 10) {
                        ForEach(0..<2) { index in
                            Rectangle()
                                .fill(index == currentPage ? Color.black : Color.gray.opacity(0.3))
                                .frame(
                                    width: index == currentPage ? width * 0.73 : width * 0.2,
                                    height: 10
                                )
                                .animation(.easeInOut(duration: 0.2), value: currentPage)
                        }
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, geometry.safeAreaInsets.bottom + 8)
                } else {
                    HStack(spacing: 12) {
                        CustomButton(title: "arrow.left", isFilled: true, action: {}, isIconOnly: true)
                            .frame(width: width * 0.15)
                        
                        CustomButton(title: "LET'S GET STARTED", isFilled: true, action: {
                        })
                        .frame(width: width * 0.8)
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 100)
                    
                }
            }
            .frame(width: geometry.size.width)
            .background(Color.white.ignoresSafeArea(edges: .bottom))
        }
        .frame(height: currentPage==2 ? 70 : 20)
    }
    var body: some View {
        VStack() {
            
            TabView(selection: $currentPage) {
                
                ZStack() {
                    Image("onboard_one")
                        .resizable()
                        .scaledToFill()
                        .frame(maxHeight: .infinity)
                    
                    VStack{
                        Spacer()
                            .frame(height: 600)
                        Text("DISCOVER YOUR SKIN'S TRUE SHADE")
                            .font(
                                .system(
                                    size: 32,
                                    weight:.semibold,
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
                    VStack{
                        Spacer()
                            .frame(height: 580)
                        Text("FIND THE SHADE MATCH FOR YOU")
                            .font(
                                .system(
                                    size: 32,
                                    weight:.semibold,
                                    design: .monospaced
                                )
                            )
                            .padding(.horizontal, 32)
                            .padding(.bottom, 8)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("Experience the ease of finding a foundation crafted just for your skin.")
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
                    VStack{
                        Spacer()
                            .frame(height: 580)
                        Text("READY TO MAKE A MATCH?")
                        
                            .font(.system(size: 32,weight:.semibold,design: .monospaced))
                            .padding(.horizontal, 32)
                            .padding(.bottom, 8)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("We’ll help you to uncover your true beauty.")
                            .font(.caption.weight(.regular))
                            .padding(.horizontal, 32)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                }.tag(2)
                
            }
            .ignoresSafeArea()
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            bottomSection
            
            
        }
    }
    
}

#Preview {
    OnBoardingView()
}
