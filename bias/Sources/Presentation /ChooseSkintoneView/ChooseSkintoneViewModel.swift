import SwiftUI
import AVKit
import Combine

final class ChooseSkintoneViewModel : ObservableObject {
    @Published var player: AVPlayer?
    @Published var currentStepIndex: Int = 0
    
    let steps: [SkinToneInstruction] = [
        SkinToneInstruction(
            title: "BEFORE YOU START",
            instruction: "Take off any accessories such as eyeglasses or hats, and make sure to erase your makeup.",
            duration: 6
        ),
        SkinToneInstruction(
            title: "FIT IN THE FRAME",
            instruction: "Position your face on within a frame and ensure your entire face is visible in the frame.",
            duration: 5
        ),
        SkinToneInstruction(
            title: "BRIGHTNESS SCALE",
            instruction: "For precise results, ensure good lighting, preferably natural sunlight.",
            duration: 1.95
        ),
        SkinToneInstruction(
            title: "AUTOMATIC CAPTURE",
            instruction: "After detecting your cheeks, jawlines, and neck, it will automatically capture your photo to be analyze.",
            duration: 4
        )
    ]
    
    
    
    
    init(videoName: String, videoType: String = "mp4") {
        setupPlayer(videoName: videoName, videoType: videoType)
        startTimer()
    }
    
    private var cancellables : AnyCancellable?
    private func startTimer(){
        schedulStepChange()
    }
    
    private func schedulStepChange(){
        let duration = steps[currentStepIndex].duration
        cancellables = Just(())
            .delay(for: .seconds(duration), scheduler: RunLoop.main)
            .sink{
                [weak self] _ in
                self?.moveToNextStep()
            }
    }
    
    private func moveToNextStep() {
        if currentStepIndex < steps.count - 1 {
               currentStepIndex += 1
           } else {
               currentStepIndex = 0 
           }
           schedulStepChange()
        }
    
    private func setupPlayer(videoName: String, videoType: String) {
        guard let url = Bundle.main.url(forResource: videoName, withExtension: videoType) else {
            print("⚠️ Video file not found: \(videoName).\(videoType)")
            return
        }
        
        let player = AVPlayer(url: url)
        player.isMuted = true
        player.play()
        player.actionAtItemEnd = .none
        
        
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main
        ) { [weak player] _ in
            player?.seek(to: .zero)
            player?.play()
        }
        
        self.player = player
    }
}
