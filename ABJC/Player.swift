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
    private let item: API.Models.Item
    
    @State var streamURL: URL? = nil

    init(_ item: API.Models.Item) {
        self.item = item
    }
    
    
    @State var player: AVPlayer = AVPlayer()
        
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
        let url = session.api.getStreamURL(for: item.id)
        self.streamURL = url
    }
    
    func reportProgress() {
        
    }
}


class PlayerStore: NSObject, AVPlayerViewControllerDelegate {
    
}

struct PlayerViewController: UIViewControllerRepresentable {
    let playerStore = PlayerStore()
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
        controller.delegate = self.playerStore
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
            vc.showsPlaybackControls = true
        }
        
        vc.allowsPictureInPicturePlayback = true
    }
}



