//
//  MediaItemRow.swift
//  ABJC
//
//  Created by Noah Kamara on 28.10.20.
//

import SwiftUI
import JellyKit
import URLImage

public struct MediaItemRow: View {
    @EnvironmentObject var session: SessionStore
    var label: String
    var items: [API.Models.Item]
    
    public init(_ label: String, _ items: [API.Models.Item]) {
        self.label = label
        self.items = items
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(label).font(.title3)
                .padding(.horizontal, 80)
            ScrollView([.horizontal]) {
                LazyHStack(spacing: 48) {
                    ForEach(items, id:\.id) { item in
                        NavigationLink(destination: ItemDetailView(item)) {
                            MediaItem(item)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.leading, 80)
                .padding(.bottom, 60)
                .padding(.top, 20)
            }
        }
    }
}
