//
//  CollectionView.swift
//  ABJC
//
//  Created by Noah Kamara on 27.10.20.
//

import SwiftUI
import abjc_core
import JellyKit
import URLImage

/// CollectionView for ItemType Collections
struct CollectionView: View {
    @EnvironmentObject var session: SessionStore
    
    private let type: API.Models.MediaType?
    
    public init(_ type: API.Models.MediaType? = nil) {
        self.type = type
    }
    
    
    @State var items: [API.Models.Item] = []
    
    var genres: [API.Models.Genre] {
        return items.flatMap({ ($0.genres) }).uniques
    }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: true) {
                LazyVStack(alignment: .leading) {
                    ForEach(self.genres, id:\.id) { genre in
                        MediaItemRow(genre.name, self.items.filter({ $0.genres.contains(genre) }))
                        Divider()
                    }
                }
            }.edgesIgnoringSafeArea(.horizontal)
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear(perform: load)
    }
    
    
    /// Loads Content From API
    func load() {
        items = session.items.filter({$0.type == self.type})
        session.api.getItems(type) { result in
            switch result {
                case .success(let items):
                    self.items = items
                case .failure(let error):
                    session.alert = AlertError("alerts.apierror", error.localizedDescription)
            }
        }
    }
}

struct CollectionView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionView(.movie)
        CollectionView(.series)
    }
}
