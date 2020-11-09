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
        ZStack {
            if self.session.hasUser {
                TabView() {
                    if session.preferences.showingWatchNowTab {
                        WatchNowView()
                            .tabItem({ Text("main.watchnow.tablabel") })
                            .tag(0)
                    }
                    if session.preferences.showingMoviesTab {
                        CollectionView(.movie)
                            .tabItem({ Text("main.movies.tablabel") })
                            .tag(1)
                    }
                    
                    if session.preferences.showingSeriesTab {
                        CollectionView(.series)
                            .tabItem({ Text("main.shows.tablabel") })
                            .tag(2)
                    }
                    
                    if session.preferences.showingSearchTab {
                        SearchView()
                            .tabItem({
                                Text("main.search.tablabel")
                                Image(systemName: "magnifyingglass")
                            })
                            .tag(3)
                    }
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
        .onAppear(perform: load)
    }
    
    func load() {
        session.api.getItems() { result in
            switch result {
                case .success(let items):session.updateItems(items)
                case .failure(_ ): break
            }
        }
    }
}

struct MainViewContainer_Previews: PreviewProvider {
    static var previews: some View {
        MainViewContainer()
    }
}
