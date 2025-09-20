import SwiftUI
import AVKit
import Combine

final class ChooseSkintoneViewModel: ObservableObject {
    @Published var player: AVPlayer?
    @Published var currentStepIndex: Int = 0
    @Published var steps: [SkinToneInstruction] = []
    
    private var cancellables: AnyCancellable?
    
    init(videoName: String, videoType: String = "mp4") {
        setupSteps()
        setupPlayer(videoName: videoName, videoType: videoType)
        startTimer()
    }
    
    
    private func setupSteps() {
        let rawSteps: [(String, String, Double)] = [
            ("BEFORE YOU START",
             "Take off any accessories such as eyeglasses or hats, and make sure to erase your makeup.",
             6),
            
            ("FIT IN THE FRAME",
             "Position your face on within a frame and ensure your entire face is visible in the frame.",
             5),
            
            ("BRIGHTNESS SCALE",
             "For precise results, ensure good lighting, preferably natural sunlight.",
             1.95),
            
            ("AUTOMATIC CAPTURE",
             "After detecting your cheeks, jawlines, and neck, it will automatically capture your photo to be analyze.",
             4)
        ]
        
        var cumulative: Double = 0
        self.steps = rawSteps.map { title, instruction, duration in
            let start = cumulative
            let end = cumulative + duration
            cumulative = end
            return SkinToneInstruction(title: title,
                                       instruction: instruction,
                                       duration: duration,
                                       startTime: start,
                                       endTime: end)
        }
    }
    
    
    private func startTimer() {
        scheduleStepChange()
    }
    
    private func scheduleStepChange() {
        let duration = steps[currentStepIndex].duration
        cancellables = Just(())
            .delay(for: .seconds(duration), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.moveToNextStep()
            }
    }
    
    private func moveToNextStep() {
        if currentStepIndex < steps.count - 1 {
            currentStepIndex += 1
        } else {
            currentStepIndex = 0 /
        }
        scheduleStepChange()
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
        
        // Looping
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
