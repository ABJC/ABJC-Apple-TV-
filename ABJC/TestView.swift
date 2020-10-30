//
//  TestView.swift
//  ABJC (ATV)
//
//  Created by Noah Kamara on 28.10.20.
//

import SwiftUI
import UIKit
import AVKit
import URLImage

struct TestView: View {
    var body: some View {
        GeometryReader() { geo in
            PlayerViewC(videoUrl: URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!, autostart: true)
                .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}


import SwiftUI
import UIKit
import AVKit

struct PlayerViewC : UIViewControllerRepresentable {
    var videoUrl: URL
    var autostart: Bool

    func makeUIViewController(context: UIViewControllerRepresentableContext<PlayerViewC>) -> AVPlayerViewController {
        return AVPlayerViewController()
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: UIViewControllerRepresentableContext<PlayerViewC>) {
        let source = videoUrl
        uiViewController.allowsPictureInPicturePlayback = true
        
        if (uiViewController.player == nil || (uiViewController.player!.currentItem != nil && (uiViewController.player!.currentItem!.asset as? AVURLAsset)!.url != source)) {
            
            let player = uiViewController.player ?? AVPlayer()
            player.replaceCurrentItem(with: AVPlayerItem(url: source))

//            try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback, options: [.allowAirPlay])
//            try? AVAudioSession.sharedInstance().setActive(true, options: [.notifyOthersOnDeactivation])
            
            print("PLAY")
            player.play()
            
            uiViewController.player = player
            uiViewController.showsPlaybackControls = true
        }
    }
    
}
