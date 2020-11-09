//
//  ClientPrefView.swift
//  ABJC
//
//  Created by Noah Kamara on 09.11.20.
//

import SwiftUI
import abjc_core
import JellyKit

struct ClientPrefView: View {
    @EnvironmentObject var session: SessionStore

    var body: some View {
        Form() {
            Section(header: Label("pref.client.tabs.label", systemImage: "photo.fill")) {
                Toggle("pref.client.tabs.watchnow", isOn: $session.preferences.showingWatchNowTab)
                Toggle("pref.client.tabs.movies", isOn: $session.preferences.showingMoviesTab)
                Toggle("pref.client.tabs.series", isOn: $session.preferences.showingSeriesTab)
                Toggle("pref.client.tabs.search", isOn: $session.preferences.showingSearchTab)
            }
            
            Section(header: Label("pref.client.betaflags.label", systemImage: "exclamationmark.triangle.fill")) {
//                Toggle("pref.client.betaflags.playbackreporting", isOn: $session.preferences.beta_playbackReporting)
//                Toggle("pref.client.betaflags.playbackcontinuation", isOn: $session.preferences.beta_playbackContinuation)
            }
        }
    }
}

struct ClientPrefView_Previews: PreviewProvider {
    static var previews: some View {
        ClientPrefView()
    }
}
