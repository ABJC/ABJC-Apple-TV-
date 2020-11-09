//
//  DebugMenuView.swift
//  ABJC
//
//  Created by Noah Kamara on 09.11.20.
//

import SwiftUI
import abjc_core
import URLImage


struct DebugMenuView: View {
    @EnvironmentObject var session: SessionStore
    
    var body: some View {
        Form() {
            Section(header: Label("pref.debugmenu.images.label", systemImage: "photo.fill")) {
                HStack {
                    Text("pref.debugmenu.images.identifier")
                    Spacer()
                    Text(URLImageService.shared.defaultOptions.identifier ?? "ERROR")
                }
                
                HStack {
                    Text("pref.debugmenu.images.cachePolicy")
                    Spacer()
                    Text(URLImageService.shared.defaultOptions.cachePolicy.label())
                }
                
                HStack {
                    Text("pref.debugmenu.images.expiryInterval")
                    Spacer()
                    Text(String(URLImageService.shared.defaultOptions.expiryInterval ?? 0))
                }
                
                Button(action: {
                    URLImageService.shared.cleanup()
                    session.alert = AlertError("alerts.info", "Cache was cleaned")
                }) {
                    Text("pref.debugmenu.images.cleanupcache")
                        .textCase(.uppercase)
                }
                
                Button(action: {
                    URLImageService.shared.removeAllCachedImages()
                    session.alert = AlertError("alerts.info", "Cache was cleared")
                }) {
                    Text("pref.debugmenu.images.clearcache")
                        .textCase(.uppercase)
                }
            }
        }
    }
}

extension URLImageOptions.CachePolicy {
    func label() -> LocalizedStringKey {
        switch self {
            case .ignoreCache: return "pref.debugmenu.images.cachepolicy.ignoreCache"
            case .returnCacheDontLoad: return "pref.debugmenu.images.cachepolicy.returnCacheDontLoad"
            case .returnCacheElseLoad: return "pref.debugmenu.images.cachepolicy.returnCacheElseLoad"
        }
        
    }
}
