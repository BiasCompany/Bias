import SwiftUI
import AVKit

struct ChooseSkintoneView: View {
    @StateObject var viewModel = ChooseSkintoneViewModel(videoName: "razia")
    
    var body: some View {
        ZStack {
            if let player = viewModel.player {
                CleanVideoPlayerView(player: player)
                    .ignoresSafeArea()
            } else {
                Color.black
            }
            
            VStack(alignment: .leading) {
                Spacer()
                
                
                ZStack {
                    ForEach(Array(viewModel.steps.enumerated()), id: \.element.title) { index, step in
                        if index == viewModel.currentStepIndex {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(step.title)
                                    .font(.system(size: 24, weight: .bold, design: .monospaced))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text(step.instruction)
                                    .font(.custom("SF Pro Text", size: 12))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.leading)
                            }
                            .transition(.move(edge: .bottom).combined(with: .opacity)) // 👈 fade + slide
                        }
                    }
                }
                .animation(.easeInOut(duration: 0.6), value: viewModel.currentStepIndex)
                
                HStack {
                    Spacer().layoutPriority(3)
                    CustomButton(
                        title: "Start Capture",
                        action: {
                            print("Go to next screen")
                        }, isFilled:false,
                        variant: .active
                    )
                    .frame(height: 70)
                    .layoutPriority(3)
                }
            }
            .padding(.horizontal, 32)
        }
    }
}

#Preview {
    ChooseSkintoneView()
}
