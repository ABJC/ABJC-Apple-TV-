//
//  Player.swift
//  ABJC
//
//  Created by Noah Kamara on 27.10.20.
//

import SwiftUI
import abjc_core
import JellyKit
import AVKit

struct PlayerView: View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var playerStore: PlayerStore
    
    @State var playItem: PlayerStore.PlayItem!
    @State var player: AVPlayer!
    @State var playerReady: Bool = false
    @State var alertError: AlertError? = nil
    @State var reportCounter = 0
    
    var body: some View {
        ZStack {
            Color.green
            .onAppear(perform: initPlayback)
            if playerReady {
                VideoPlayer(player: self.player)
            }
        }
        .onDisappear(perform: {self.playerStore.stoppedPlayback(playItem, player)})
        .edgesIgnoringSafeArea(.all)
        .alert(item: self.$alertError) { (alertError) -> Alert in
            Alert(title: Text(alertError.title), message: Text(alertError.description), dismissButton: .default(Text("buttons.ok")))
        }
    }
    
    func initPlayback() {
        let asset = session.api.getPlayerItem(for: playerStore.playItem!.id, playerStore.playItem!.sourceId)
        self.player = AVPlayer(playerItem: AVPlayerItem(asset: asset))
        
        self.playItem = playerStore.playItem
        
        _ = self.player.observe(\.currentItem?.status) { (player, value) in
            if value.newValue == .failed {
                self.alertError = AlertError("alerts.playbackerror", "alerts.playbackerror.descr")
            }
        }
        
        self.player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 10.0, preferredTimescale: 1), queue: .main) { (time) in
            self.playerStore.reportPlayback(player, time.seconds)
        }
        
        self.player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 10, preferredTimescale: 1), queue: .main) { time in
            if reportCounter < 10 {
                self.reportCounter += 1
            } else {
                reportCounter = 0
                self.playerStore.reportPlayback(player, time.seconds*10)
            }
        }
        
        player.play()
        self.playerStore.startedPlayback(player)
        self.playerReady = true
    }
    
    func reportProgress() {
        
    }
}

struct PlayerViewController: UIViewControllerRepresentable {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var playerStore: PlayerStore
    @Binding var player: AVPlayer

    func makeUIViewController(context: UIViewControllerRepresentableContext<PlayerViewController>) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        return controller
    }
    
    func updateUIViewController(_ vc: AVPlayerViewController, context: UIViewControllerRepresentableContext<PlayerViewController>) {
        if vc.player == nil {
            vc.player = self.player
            try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback, options: [.allowAirPlay])
            try? AVAudioSession.sharedInstance().setActive(true, options: [.notifyOthersOnDeactivation])
            vc.player?.play()
            vc.showsPlaybackControls = true
            self.playerStore.startedPlayback(vc.player)
        }
    }
}

