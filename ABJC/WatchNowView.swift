//
//  WatchNowView.swift
//  ABJC (ATV)
//
//  Created by Noah Kamara on 28.10.20.
//

import SwiftUI
import abjc_core
import JellyKit

struct WatchNowView: View {
    @EnvironmentObject var session: SessionStore
    
    @State var resumableItems: [API.Models.Item] = []
    @State var favoriteItems: [API.Models.Item] = []
    @State var latestItems: [API.Models.Item] = []
    
    var body: some View {
        NavigationView {
            ScrollView([.vertical]) {
                LazyVStack(alignment: .leading) {
                    
                    /// Resumable Items
                    if !resumableItems.isEmpty {
                        MediaItemRow("watchnow.continueWatching", self.resumableItems)
                        Divider()
                    }
                    
                    /// Favorite Items
                    if !favoriteItems.isEmpty {
                        Divider()
                        MediaItemRow("watchnow.favorites", self.favoriteItems)
                    }
                    
                    /// Latest Items
                    if !latestItems.isEmpty {
                        if !latestItems.filter({$0.type == .movie}).isEmpty {
                            Divider()
                            MediaItemRow("watchnow.latestMovies", self.latestItems.filter({$0.type == .movie}))
                        }
                        
                        if !latestItems.filter({$0.type == .series}).isEmpty {
                            Divider()
                            MediaItemRow("watchnow.latestShows", self.latestItems.filter({$0.type == .series}))
                        }
                    }
                }
            }.edgesIgnoringSafeArea(.horizontal)
        }.edgesIgnoringSafeArea(.all)
        .onAppear(perform: load)
    }
    
    
    /// Loads Content From API
    func load() {
        session.api.getLatest() { (result) in
            switch result {
            case .success(let items): self.latestItems = items
            case .failure(let error):
                print(error)
                session.alert = AlertError("alerts.apierror", error.localizedDescription)
            }
        }
        
        session.api.getResumable { (result) in
            switch result {
            case .success(let items): self.resumableItems = items
            case .failure(let error): session.alert = AlertError("alerts.apierror", error.localizedDescription)
            }
        }
        
        session.api.getFavorites { (result) in
            switch result {
            case .success(let items): self.favoriteItems = items
            case .failure(let error): session.alert = AlertError("alerts.apierror", error.localizedDescription)
            }
        }
    }
}
