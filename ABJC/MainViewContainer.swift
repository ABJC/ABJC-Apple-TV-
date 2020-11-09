//
//  MainViewContainer.swift
//  ABJC
//
//  Created by Noah Kamara on 27.10.20.
//

import SwiftUI
import abjc_core
import JellyKit
import AVKit

struct MainViewContainer: View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var playerStore: PlayerStore
    
    var body: some View {
        Group() {
            if self.session.hasUser {
                TabView() {
                    WatchNowView()
                        .tabItem({ Text("main.watchnow.tablabel") })
                        .tag(0)
                    CollectionView(.movie)
                        .tabItem({ Text("main.movies.tablabel") })
                        .tag(1)
                    CollectionView(.series)
                        .tabItem({ Text("main.shows.tablabel") })
                        .tag(2)
                    SearchView()
                        .tabItem({
                            Text("main.search.tablabel")
                            Image(systemName: "magnifyingglass")
                        })
                        .tag(3)
                    PreferencesView()
                        .tabItem({ Text("main.preferences.tablabel") })
                        .tag(4)
                }
            } else {
                AuthView()
            }
        }
        .alert(item: $session.alert) { (alert) -> Alert in
            Alert(title: Text(alert.title), message: Text(alert.description), dismissButton: .default(Text("buttons.ok")))
        }
    }
}

struct MainViewContainer_Previews: PreviewProvider {
    static var previews: some View {
        MainViewContainer()
    }
}
