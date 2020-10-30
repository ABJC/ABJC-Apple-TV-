//
//  ItemDetailView.swift
//  ABJC
//
//  Created by Noah Kamara on 27.10.20.
//

import SwiftUI
import JellyKit
import URLImage

struct ItemDetailView: View {
    @EnvironmentObject var session: SessionStore
    
    private var item: API.Models.Item
    init(_ item: API.Models.Item) {
        self.item = item
    }
    
    
    @State var movie: API.Models.Movie? = nil
    
    @State var images: [API.Models.Image] = []
    @State var similar: [API.Models.Item] = []
    @State var isPlaying: Bool = false
    
    
    var body: some View {
        switch item.type {
            case .movie: self.movieDetail
            default: self.seriesDetail
        }
    }
    
    var movieDetail: some View {
        GeometryReader() { geo in
            ScrollView([.vertical]) {
                VStack(alignment: .leading) {
                    Spacer()
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            if (self.images.contains(where: {$0.imageType == .logo})) {
                                URLImage(url: session.api.getImageURL(for: item.id, .logo),
                                         options: URLImageOptions(
                                            identifier: item.id+API.Models.ImageType.logo.rawValue,
                                            expireAfter: .infinity,
                                            cachePolicy: .returnCacheReload(cacheDelay: nil, downloadDelay: 0.25)
                                         ),
                                 inProgress: { progress in
                                    Text(self.movie?.name ?? "")
                                        .bold()
                                        .font(.title2)
                                },
                                 failure: { error, retry in
                                    Text(self.movie?.name ?? "")
                                        .bold()
                                        .font(.title2)
                                }, content: { image in
                                    image
                                        .renderingMode(.original)
                                        .resizable()
                                })
                                .clipped()
                                .frame(height: 300)
                            } else {
                                Text(self.movie?.name ?? "")
                                    .bold()
                                    .font(.title2)
                            }
                            Text(self.movie?.year != nil ? "\(String(self.movie!.year!))" : "")
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Button(action: {self.isPlaying.toggle()}) {
                            VStack() {
                                Text("PLAY")
                                    .bold()
                            }.frame(width: 300)
                        }.foregroundColor(.accentColor)
                        .padding(.trailing)
                    }
                    Divider()
                    HStack() {
                        Text(self.movie?.overview ?? "")
                    }
                }.frame(height: geo.size.height).padding(.horizontal, 80)
                
                if self.movie?.people?.count != 0 {
                    Divider()
                    PeopleRow(self.movie?.people ?? [])
                }
                
                if self.similar.count != 0 {
                    Divider()
                    MediaItemRow("Recommended", self.similar)
                }
            }
            .onAppear(perform: loadMovie)
        }
        .edgesIgnoringSafeArea(.horizontal)
        .fullScreenCover(isPresented: self.$isPlaying) {
            PlayerView(item)
        }
    }
    
    var seriesDetail: some View {
        Text("SERIES DETAIL")
    }
    
    func loadMovie() {
        print(self.item.id)
        session.api.getImages(for: self.item.id) { result in
            switch result {
            case .success(let images): self.images = images
            case .failure(let error): print(error)
            }
        }
        session.api.getMovie(self.item.id) { result in
            switch result {
            case .success(let item): self.movie = item
            case .failure(let error): print(error)
            }
        }
        session.api.getSimilar(for: self.item.id) { result in
            switch result {
            case .success(let items): self.similar = items
            case .failure(let error): print(error)
            }
        }
    }
}

//struct ItemDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemDetailView()
//    }
//}
