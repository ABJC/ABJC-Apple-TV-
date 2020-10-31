//
//  Player.swift
//  ABJC
//
//  Created by Noah Kamara on 27.10.20.
//

import SwiftUI
import JellyKit
import AVKit

struct PlayerView: View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var player: PlayerStore
        
    @State var streamURL: URL? = nil
    var body: some View {
        ZStack {
            Color.primary
            .onAppear(perform: initPlayback)
            if streamURL != nil {
                PlayerViewController(url: self.streamURL!)
            }
        }.edgesIgnoringSafeArea(.all)
    }
    
    func initPlayback() {
        
        let url = session.api.getStreamURL(for: player.playItem!.id)
        print(url)
        self.streamURL = url
    }
    
    func reportProgress() {
        
    }
}

struct PlayerViewController: UIViewControllerRepresentable {
    let delegate = PlayerDelegate()
    var videoURL: URL? = nil
    var videoData: Data? = nil
    var autostart: Bool
    
    public init(url: URL, _ autostart: Bool = true) {
        self.videoURL = url
        self.autostart = autostart
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<PlayerViewController>) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.allowsPictureInPicturePlayback = true
        controller.isSkipBackwardEnabled = true
        controller.isSkipBackwardEnabled = true
        controller.playbackControlsIncludeInfoViews = true
        controller.playbackControlsIncludeTransportBar = true
        controller.showsPlaybackControls = true
        controller.delegate = delegate
        return controller
    }
    
    func updateUIViewController(_ vc: AVPlayerViewController, context: UIViewControllerRepresentableContext<PlayerViewController>) {
        let source = videoURL!
        let playerItem = AVPlayerItem(url: source)
        
        if (vc.player == nil || (vc.player!.currentItem != nil && (vc.player!.currentItem!.asset as? AVURLAsset)!.url != source)) {
            let player = vc.player ?? AVPlayer()
            player.replaceCurrentItem(with: playerItem)
            
            try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback, options: [.allowAirPlay])
            try? AVAudioSession.sharedInstance().setActive(true, options: [.notifyOthersOnDeactivation])
            
            vc.player = player
            vc.player?.play()
            vc.showsPlaybackControls = true
            
        }
        
        vc.allowsPictureInPicturePlayback = true
    }
}

class PlayerDelegate: NSObject, AVPlayerViewControllerDelegate {
}



