//
//  WatchNowView.swift
//  ABJC (ATV)
//
//  Created by Noah Kamara on 28.10.20.
//

import SwiftUI
import JellyKit

struct WatchNowView: View {
    @EnvironmentObject var session: SessionStore
    @Binding var alertError: AlertError?
    
    @State var resumableItems: [API.Models.Item] = []
    @State var favoriteItems: [API.Models.Item] = []
    @State var latestItems: [API.Models.Item] = []
    
    public init(_ alertError: Binding<AlertError?>) {
        self._alertError = alertError
    }
    
    var body: some View {
        NavigationView {
            ScrollView([.vertical]) {
                LazyVStack(alignment: .leading) {
                    MediaItemRow("watchnow.continueWatching", self.resumableItems)
                    Divider()
                    MediaItemRow("watchnow.favorites", self.favoriteItems)
                    Divider()
                    MediaItemRow("watchnow.latestMovies", self.latestItems.filter({$0.type == .movie}))
                    Divider()
                    MediaItemRow("watchnow.latestShows", self.latestItems.filter({$0.type == .series}))
                }
            }.edgesIgnoringSafeArea(.horizontal)
            .onAppear(perform: load)
        }.edgesIgnoringSafeArea(.all)
    }
    
    func load() {
        session.api.getLatest() { (result) in
            switch result {
            case .success(let items): self.latestItems = items
            case .failure(let error): self.alertError = AlertError("alerts.apierror", error.localizedDescription)
            }
        }
        
        session.api.getResumable { (result) in
            switch result {
            case .success(let items): self.resumableItems = items
            case .failure(let error): self.alertError = AlertError("alerts.apierror", error.localizedDescription)
            }
        }
        
        session.api.getFavorites { (result) in
            switch result {
            case .success(let items): self.favoriteItems = items
            case .failure(let error): self.alertError = AlertError("alerts.apierror", error.localizedDescription)
            }
        }
        
    }
}
