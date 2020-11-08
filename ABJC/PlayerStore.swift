//
//  PlayerStore.swift
//  ABJC
//
//  Created by Noah Kamara on 31.10.20.
//

import Foundation
import Combine
import AVKit
import JellyKit

class PlayerStore: ObservableObject {
    @Published public var playItem: PlayItem? = nil
    @Published public var api: API? = nil
    public var statusObserver: NSKeyValueObservation? = nil
    public var errorObserver: NSKeyValueObservation? = nil
    
    private var timer: Timer? = nil
    
    public func play(_ episode: API.Models.Episode) {
        print("PLAYING", episode.name, episode.index ?? 0, episode.id)
        self.playItem = PlayItem(episode)
    }
    
    public func play(_ movie: API.Models.Movie) {
        self.playItem = PlayItem(movie)
    }
    
//    public func play(_ season: API.Models.Season) {
//        self.playItem = PlayItem(season)
//    }
    
    public func startedPlayback(_ player: AVPlayer?) {
//        print("STARTED PLAYBACK")
        self.api?.startPlayback(for: self.playItem!.id, at: 0)
    }
    
    public func reportPlayback(_ player: AVPlayer?, _ pos: Double) {
        if let item = playItem {
            self.api?.reportPlayback(for: item.id, positionTicks: Int(pos*1000000))
        }
    }
    
    public func stoppedPlayback(_ item: PlayItem, _ player: AVPlayer?) {
        if let playbackPosition = player?.currentTime().seconds {
            let posTicks = Int(playbackPosition * 1000000)
            self.api?.stopPlayback(for: item.id, positionTicks: posTicks)
        } else {
            print("ERROR", player)
        }
    }
}


extension PlayerStore {
    class PlayItem: Identifiable {
        public let id: String
        public let sourceId: String
        private let userData: API.Models.UserData
        
        public init(_ item: Playable) {
            self.id = item.id
            self.sourceId = item.mediaSources.first?.id ?? ""
            self.userData = item.userData
        }
    }
}
