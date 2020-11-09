//
//  MediaItemRow.swift
//  ABJC
//
//  Created by Noah Kamara on 28.10.20.
//

import SwiftUI
import abjc_core
import JellyKit
import URLImage

public struct MediaItemRow: View {
    @EnvironmentObject var session: SessionStore
    var label: LocalizedStringKey
    var items: [API.Models.Item]
    
    public init(_ label: String, _ items: [API.Models.Item]) {
        self.label = LocalizedStringKey(label)
        self.items = items
    }
    
    public init(_ label: LocalizedStringKey, _ items: [API.Models.Item]) {
        self.label = label
        self.items = items
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(label)
                .font(.title3)
                .padding(.horizontal, 80)
            ScrollView(.horizontal) {
//                LazyHGrid(rows: [GridItem()], spacing: 48) {
//                    ForEach(items, id:\.id) { item in
//                        NavigationLink(destination: ItemDetailView(item)) {
//                            MediaItem(item)
//                        }
//                        .buttonStyle(PlainButtonStyle())
//                    }
//                }
                LazyHStack(spacing: 48) {
                    ForEach(items, id:\.id) { item in
                        NavigationLink(destination: ItemDetailView(item)) {
                            MediaItem(item)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.leading, 80)
                .padding(.bottom, 50)
                .padding(.top)
            }
        }
    }
}
