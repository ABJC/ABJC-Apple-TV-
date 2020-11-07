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
    @EnvironmentObject var session: SessionStore
    
    @State var player: AVPlayer!
    @State var playerReady: Bool = false
    var body: some View {
        ZStack {
            Color.green
            .onAppear(perform: initPlayback)
//            PlayerViewController(player: self.$player)
            if playerReady {
                VideoPlayer(player: self.player)
            }
        }.edgesIgnoringSafeArea(.all)
    }
    
    func initPlayback() {
        let asset = session.api.getPlayerItem(for: "playerStore.playItem!.id", "playerStore.playItem!.sourceId")
        self.player = AVPlayer(playerItem: AVPlayerItem(asset: asset))
        player.play()
        self.playerReady = true
    }
    
    func reportProgress() {
        
    }
}


