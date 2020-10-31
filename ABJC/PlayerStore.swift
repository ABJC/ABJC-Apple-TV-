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
    
    public func play(_ episode: API.Models.Episode) {
        print("PLAYING", episode.name, episode.index ?? 0, episode.id)
        self.playItem = PlayItem(episode)
    }
    
    public func play(_ item: API.Models.Item) {
        self.playItem = PlayItem(item)
    }
    
    public func play(_ season: API.Models.Season) {
//        self.playItem = PlayItem(season)
    }
    
}


extension PlayerStore {
    class PlayItem: Identifiable {
        public let id: String
        
        public init(_ item: Playable) {
            self.id = item.id
        }
    }
}
