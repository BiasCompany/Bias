//
//  CleanVideoPlayerView.swift
//  bias
//
//  Created by Muhammad Rifqi Syatria on 9/19/25.
//


import SwiftUI
import AVKit

struct CleanVideoPlayerView: UIViewControllerRepresentable {
    let player: AVPlayer?
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.showsPlaybackControls = false
        controller.player = player
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        uiViewController.player = player
    }
}
