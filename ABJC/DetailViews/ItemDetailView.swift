//
//  ItemDetailView.swift
//  ABJC
//
//  Created by Noah Kamara on 27.10.20.
//

import SwiftUI
import abjc_core
import JellyKit
import URLImage


struct ItemDetailView: View {
    @EnvironmentObject var session: SessionStore
    
    private let item: API.Models.Item
    
    public init(_ item: API.Models.Item) {
        self.item = item
    }
    
    var body: some View {
        GeometryReader() { geo in
            if item.type == .movie {
                MovieDetailView(item, geo)
            } else if item.type == .series {
                SeriesDetailView(item, geo)
            } else {
                ZStack {
                    EmptyView()
                    Text("ERROR")
                }
            }
        }.edgesIgnoringSafeArea(.horizontal)
    }
}
