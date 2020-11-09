//
//  ServerInfoView.swift
//  ABJC (ATV)
//
//  Created by Noah Kamara on 30.10.20.
//

import SwiftUI
import abjc_core
import JellyKit


struct ServerInfoView: View {
    @EnvironmentObject var session: SessionStore
    @State var systemInfo: API.Models.SystemInfo? = nil
    
    var body: some View {
        Group() {
            if let data = systemInfo {
                Form() {
                    Section(header: Label("pref.serverinfo.general.label", systemImage: "externaldrive.connected.to.line.below")) {
                        HStack {
                            Text("pref.serverinfo.servername.label")
                            Spacer()
                            Text(data.serverName)
                        }.focusable(true)
                        HStack {
                            Text("pref.serverinfo.version.label")
                            Spacer()
                            Text(data.version)
                        }
                        HStack {
                            Text("pref.serverinfo.id.label")
                            Spacer()
                            Text(data.serverId)
                        }
                        HStack {
                            Text("pref.serverinfo.os.label")
                            Spacer()
                            Text(data.operatingSystemName)
                        }
                        HStack {
                            Text("pref.serverinfo.architecture.label")
                            Spacer()
                            Text(data.systemArchitecture)
                        }
                    }
                    Section(header: Label("pref.serverinfo.networking.label", image: "network")) {
                        HStack {
                            Text("pref.serverinfo.host.label")
                            Spacer()
                            Text(data.host)
                        }
                        HStack {
                            Text("pref.serverinfo.port.label")
                            Spacer()
                            Text(String(data.port))
                        }
                    }
                }
            } else {
                ProgressView()
            }
        }.onAppear(perform: load)
    }
    
    func load() {
        session.api.getSystemInfo() { result in
            switch result {
            case .success(let systemInfo): self.systemInfo = systemInfo
            case .failure(let error): print(error)
            }
        }
    }
}
