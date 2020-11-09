//
//  MovieDetailView.swift
//  ABJC
//
//  Created by Noah Kamara on 31.10.20.
//

import SwiftUI
import abjc_core
import JellyKit
import URLImage

struct MovieDetailView: View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var playerStore: PlayerStore
    
    private let item: API.Models.Item
    private let geo: GeometryProxy
    
    public init(_ item: API.Models.Item, _ geo: GeometryProxy) {
        self.item = item
        self.geo = geo
    }
    
    @State var detailItem: API.Models.Movie?
    
    @State var images: [API.Models.Image] = []
    @State var similarItems: [API.Models.Item] = []
    
    
    /// Loads Content From API
    func load() {
        // Fetch Item Detail
        session.api.getMovie(item.id) { result in
            switch result {
            case .success(let item): self.detailItem = item
            case .failure(let error): session.alert = AlertError("alerts.apierror", error.localizedDescription)
            }
        }
        
        // Fetch Images for Item
        session.api.getImages(for: item.id) { result in
            switch result {
            case .success(let images): self.images = images
            case .failure(let error): session.alert = AlertError("alerts.apierror", error.localizedDescription)
            }
        }
        
        // Fetch Similar Items
        session.api.getSimilar(for: item.id) { result in
            switch result {
            case .success(let items): self.similarItems = items
            case .failure(let error): session.alert = AlertError("alerts.apierror", error.localizedDescription)
            }
        }
    }
    
    var body: some View {
        ScrollView([.vertical]) {
            headerView
            infoView
            peopleView
            recommendedView
        }
        .fullScreenCover(item: $playerStore.playItem) {_ in
            PlayerView()
        }
        .onAppear(perform: load)
    }
    
    var headerView: some View {
        VStack(alignment: .leading) {
            Spacer()
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(item.name)
                        .bold()
                        .font(.title2)
                    Text(item.year != nil ? "\(String(item.year!))" : "")
                        .foregroundColor(.secondary)
                }
                Spacer()
                Button(action: {
                    if let item = self.detailItem {
                        playerStore.play(item)
                    }
                }) {
                    Text("buttons.play")
                        .bold()
                        .textCase(.uppercase)
                        .frame(width: 300)
                }.foregroundColor(.accentColor)
                .padding(.trailing)
            }.disabled(detailItem == nil)
            if item.overview != nil {
                Divider()
                HStack() {
                    Text(self.item.overview ?? "")
                }
            }
        }
        .frame(height: geo.size.height)
        .padding(.horizontal, 80)
        .padding(.bottom, 80)
    }
    
    var peopleView: some View {
        Group {
            if self.detailItem?.people?.count != 0 {
                Divider().padding(.horizontal, 80)
                PeopleRow(self.detailItem?.people ?? [])
            } else {
                EmptyView()
            }
        }.edgesIgnoringSafeArea(.horizontal)
    }
    
    var infoView: some View {
        VStack {
            EmptyView()
        }
    }
    
    var recommendedView: some View {
        Group {
            if self.similarItems.count != 0 {
                Divider().padding(.horizontal, 80)
                MediaItemRow("itemdetail.recommended.label", self.similarItems)
            } else {
                EmptyView()
            }
        }
    }
}
