//
//  ServerInfoView.swift
//  ABJC (ATV)
//
//  Created by Noah Kamara on 30.10.20.
//

import SwiftUI
import JellyKit

struct ServerInfoView: View {
    @EnvironmentObject var session: SessionStore
    @State var systemInfo: API.Models.SystemInfo? = nil
    
    var body: some View {
        Group() {
            if let data = systemInfo {
                Form() {
                    Section(header: Label("prefs_systemInfo_general", image: "externaldrive.connected.to.line.below")) {
                        HStack {
                            Text("systemInfo_serverName")
                            Spacer()
                            Text(data.serverName)
                        }.focusable(true)
                        HStack {
                            Text("systemInfo_version")
                            Spacer()
                            Text(data.version)
                        }
                        HStack {
                            Text("systemInfo_erverId")
                            Spacer()
                            Text(data.serverId)
                        }
                        HStack {
                            Text("systemInfo_operatingSystem")
                            Spacer()
                            Text(data.operatingSystemName)
                        }
                        HStack {
                            Text("systemInfo_systemArchitecture")
                            Spacer()
                            Text(data.systemArchitecture)
                        }
                    }
                    Section(header: Label("prefs_systemInfo_networking", image: "network")) {
                        HStack {
                            Text("systemInfo_host")
                            Spacer()
                            Text(data.host)
                        }
                        HStack {
                            Text("systemInfo_port")
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
