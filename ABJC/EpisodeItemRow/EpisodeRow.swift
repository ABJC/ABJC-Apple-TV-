//
//  EpisodeRow.swift
//  ABJC
//
//  Created by Noah Kamara on 31.10.20.
//

import SwiftUI
import JellyKit
import URLImage

public struct EpisodeItemRow: View {
    @EnvironmentObject var session: SessionStore
    @Binding var selectedEpisode: API.Models.Episode?
    
    var label: LocalizedStringKey
    var items: [API.Models.Episode]
    
    public init(_ label: String, _ items: [API.Models.Episode], _ selection: Binding<API.Models.Episode?>) {
        self.label = LocalizedStringKey(label)
        self.items = items
        self._selectedEpisode = selection
    }
    
    public init(_ label: LocalizedStringKey, _ items: [API.Models.Episode], _ selection: Binding<API.Models.Episode?>) {
        self.label = label
        self.items = items
        self._selectedEpisode = selection
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.title3)
                .padding(.horizontal, 80)
            ScrollView([.horizontal]) {
                LazyHStack(spacing: 48) {
                    ForEach(items, id:\.id) { item in
                        VStack {
                            Button(action: {
                                print(session.api.getImageURL(for: item.id, .thumb))
                                selectedEpisode = item
                            }) {
                                EpisodeItem(item)
                            }
                            .buttonStyle(PlainButtonStyle())
                            Text("Episode \(item.index ?? 0)")
                                .font(.callout)
                                .foregroundColor(.secondary)
                            Text(item.name)
                                .bold()
                        }
                    }
                }
                .padding(.leading, 80)
                .padding(.bottom, 60)
            }
        }
    }
}
