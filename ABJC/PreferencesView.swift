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
                    Label("Server Info", systemImage: "server.rack")
                }
                NavigationLink(destination: ServerInfoView()) {
                    Label("Server Info", systemImage: "server.rack")
                }
                Button(action: {
                    self.session.clear()
                }) {
                    HStack {
                        Spacer()
                        Text("logout")
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


