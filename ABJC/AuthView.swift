//
//  AuthView.swift
//  ABJC (ATV)
//
//  Created by Noah Kamara on 28.10.20.
//

import SwiftUI
import JellyKit
struct AuthView: View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var playerStore: PlayerStore
    
    @State var progress: Bool = false
    @State var serverSelection: Bool = true
    @State var didTrySignIn: Bool = false
    var body: some View {
        NavigationView {
            if !didTrySignIn {
                ProgressView()
                    .onAppear(perform: authorize)
            } else {
                ServerSelectionView()
            }
        }
    }
    func authorize() {
        if let data = KeyChain.load(key: "credentials") {
            if let credentials = try? JSONDecoder().decode(ServerLocator.ServerCredential.self, from: data) {
                let api = session.setServer(credentials.host, credentials.port, credentials.deviceId)
                api.authorize(credentials.username, credentials.password) { (result) in
                    switch result {
                    case .success(let authResponse):
                        DispatchQueue.main.async {
                            self.session.user = API.AuthUser(id: authResponse.user.id,
                                                             name: authResponse.user.name,
                                                             serverID: authResponse.serverId,
                                                             deviceID: credentials.deviceId,
                                                             token: authResponse.token)
                            self.playerStore.api = self.session.api
                        }
                    case .failure(let error):
                        print(error)
                        self.didTrySignIn.toggle()
                    }
                }
            } else {
                self.didTrySignIn.toggle()
            }
        } else {
            self.didTrySignIn.toggle()
        }
    }
        
    struct ServerSelectionView: View {
        @EnvironmentObject var session: SessionStore
        private let locator: ServerLocator = ServerLocator()
        
        @State var host: String = ""
        @State var port: String = "8096"
        
        @State var discoveredServers: [ServerLocator.ServerLookupResponse] = []

        var body: some View {
            VStack {
                Spacer()
                ScrollView([.horizontal]) {
                    LazyHStack(alignment: .center) {
                        NavigationLink(destination: ManualServerEntry()) {
                            VStack {
                                Text("auth.serverselection.manual.label")
                                    .bold()
                                    .font(.headline)
                                    .textCase(.uppercase)
                                Text("auth.serverselection.manual.descr")
                                    .font(.callout)
                                    .foregroundColor(.secondary)
                            }
                        }
                        ForEach(self.discoveredServers, id:\.id) { server in
                            NavigationLink(destination: AccountCredentialView(server.host, server.port)) {
                                VStack {
                                    Text(server.name)
                                        .bold()
                                        .font(.headline)
                                        .textCase(.uppercase)
                                    Text("\(server.host):\(String(server.port))")
                                        .font(.system(.callout, design: .monospaced))
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }.onAppear(perform: discover)
                Spacer()
            }
            .navigationTitle("auth.serverselection.title")
        }
        
        func discover() {
            locator.locateServer { (server) in
                if server != nil {
                    if !discoveredServers.contains(server!) {
                        discoveredServers.append(server!)
                    }
                }
            }
        }
    }
    
    struct ManualServerEntry: View {
        @State var host: String = "michaels.dynv6.net"
        @State var port: String = "8096"
        var body: some View {
            Group() {
                TextField("auth.serverselection.host.label", text: self.$host)
                TextField("auth.serverselection.port.label", text: self.$port)
                    .textContentType(.oneTimeCode)
                    .keyboardType(.numberPad)
            }.frame(width: 400)
            NavigationLink(destination: AccountCredentialView(self.host, Int(self.port) ?? 8096)) {
                Text("buttons.continue").textCase(.uppercase)
            }
        }
    }
    
    struct AccountCredentialView: View {
        @EnvironmentObject var session: SessionStore
        @EnvironmentObject var playerStore: PlayerStore
        
        private let host: String
        private let port: Int
        
        @State var username: String = "soeren"
        @State var password: String = ""
        
        @State var showingAlert: Bool = false
        
        init(_ host: String, _ port: Int) {
            self.host = host
            self.port = port
        }
        var body: some View {
            NavigationView {
                VStack {
                    Group() {
                        VStack {
                            Text("\(session.host)")
                                .font(.callout)
                                .foregroundColor(.secondary)
                        }
                        TextField("auth.credentials.username.label", text: self.$username)
                            .textContentType(.username)
                        SecureField("auth.credentials.password.label", text: self.$password)
                            .textContentType(.password)
                    }.frame(width: 400)
                    
                    Button(action: authorize) {
                        Text("buttons.signin").textCase(.uppercase)
                    }
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("auth.credentials.error.label"), message: Text("auth.credentials.error.descr"), dismissButton: .default(Text("buttons.retry")))
                }
                
                .navigationTitle("auth.credentials.title")
            }
            .onAppear() {
                _ = session.setServer(self.host, self.port, UUID().uuidString)
            }
        }
        
        func authorize() {
            session.api.authorize(username, password) { (result) in
                switch result {
                case .success(let authResponse):
                    DispatchQueue.main.async {
                        let credentials = ServerLocator.ServerCredential(session.host,
                                                                         session.port,
                                                                         username,
                                                                         password)
                        if let data = try? JSONEncoder().encode(credentials) {
                            _ = KeyChain.save(key: "credentials", data: data)
                        }
                        
                        self.session.user = API.AuthUser(id: authResponse.user.id,
                                                         name: authResponse.user.name,
                                                         serverID: authResponse.serverId,
                                                         deviceID: credentials.deviceId,
                                                         token: authResponse.token)
                        self.playerStore.api = self.session.api
                    }
                case .failure(let error):
                    print(error)
                    self.showingAlert.toggle()
                }
            }
        }
    }
}
