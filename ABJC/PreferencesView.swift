//
//  PreferencesView.swift
//  ABJC (ATV)
//
//  Created by Noah Kamara on 30.10.20.
//

import SwiftUI
import abjc_core
import JellyKit

struct PreferencesView: View {
    @EnvironmentObject var session: SessionStore
    var body: some View {
        NavigationView {
            Form {
                NavigationLink(destination: ServerInfoView()) {
                    Label("pref.serverinfo.label", systemImage: "server.rack")
                }
                
                NavigationLink(destination: ClientPrefView()) {
                    Label("pref.client.label", systemImage: "tv")
                }
                
                NavigationLink(destination: DebugMenuView()) {
                    Label("pref.debugmenu.label", systemImage: "exclamationmark.triangle.fill")
                }
                
                Button(action: {
                    self.session.clear()
                }) {
                    HStack {
                        Spacer()
                        Text("buttons.logout")
                            .bold()
                            .textCase(.uppercase)
                            .foregroundColor(.red)
                            
                        Spacer()
                    }
                }
            }
            ServerInfoView()
        }.navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
    }
}


