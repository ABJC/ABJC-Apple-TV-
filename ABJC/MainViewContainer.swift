//
//  MainViewContainer.swift
//  ABJC
//
//  Created by Noah Kamara on 27.10.20.
//

import SwiftUI
import JellyKit
import AVKit

struct MainViewContainer: View {
    @EnvironmentObject var session: SessionStore
    
    
    let headers = [
        "X-Emby-Authorization": "Emby Client=abjc, Device=iOS, DeviceId=12345678, Version=1.0.0",
        "X-Emby-Token": "9620aeea9b17463bbe89675f97b8fe7e"
    ]
    var body: some View {
        if self.session.hasUser {
            TabView() {
                WatchNowView()
                    .tabItem({ Text("watchnow_tab_label") })
                    .tag(0)
                CollectionView(.movie)
                    .tabItem({ Text("movies_tab_label") })
                    .tag(1)
                CollectionView(.series)
                    .tabItem({ Text("shows_tab_label") })
                    .tag(2)
                SearchView()
                    .tabItem({
                        Text("search_tab_label")
                        Image(systemName: "magnifyingglass")
                    })
                    .tag(3)
                PreferencesView()
                    .tabItem({ Text("preferences_tab_label") })
                    .tag(4)
            }
        } else {
            AuthView()
        }
    }
}

struct MainViewContainer_Previews: PreviewProvider {
    static var previews: some View {
        MainViewContainer()
    }
}
