//
//  PreferencesView.swift
//  ABJC (ATV)
//
//  Created by Noah Kamara on 30.10.20.
//

import SwiftUI
import JellyKit

struct PreferencesView: View {
    @EnvironmentObject var session: SessionStore
    var body: some View {
        NavigationView {
            Form {
                NavigationLink(destination: ServerInfoView()) {
                    Label("pref.serverinfo.label", systemImage: "server.rack")
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
        }.navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
    }
}


