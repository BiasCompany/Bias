//
//  CleanVideoPlayerView.swift
//  lumi
//
//  Created by Muhammad Rifqi Syatria on 9/19/25.
//

import AVKit
import SwiftUI

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
