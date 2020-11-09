//
//  EpisodeItem.swift
//  ABJC
//
//  Created by Noah Kamara on 31.10.20.
//

import SwiftUI
import URLImage
import abjc_core
import JellyKit

public struct EpisodeItem: View {
    @EnvironmentObject var session: SessionStore
    var item: API.Models.Episode
    
    public init(_ item: API.Models.Episode) {
        self.item = item
    }
    
    private var placeholder: some View {
        Image(uiImage: UIImage(blurHash: self.item.blurHash(for: .backdrop) ?? self.item.blurHash(for: .primary) ?? "", size: CGSize(width: 32, height: 32)) ?? UIImage())
            .renderingMode(.original)
            .resizable()
    }
    
    public var body: some View {
        ZStack {
            Blur().clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            URLImage(
                url: session.api.getImageURL(for: item.id, .thumb),
                empty: { self.placeholder },
                inProgress: { progress in
                    Group {
                        if progress != nil {
                            Image(uiImage: UIImage(blurHash: self.item.blurHash(for: .backdrop) ?? self.item.blurHash(for: .primary) ?? "", size: CGSize(width: 32, height: 32)) ?? UIImage())
                                .renderingMode(.original)
                                .resizable()
                        }
                        else {
                            Image(uiImage: UIImage(blurHash: self.item.blurHash(for: .backdrop) ?? self.item.blurHash(for: .primary) ?? "", size: CGSize(width: 32, height: 32)) ?? UIImage())
                                .renderingMode(.original)
                                .resizable()
                        }
                    }
                },
                failure:  { _,_ in self.placeholder }
            ) { image in
                    image
                        .renderingMode(.original)
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
        }
        .aspectRatio(16/9, contentMode: .fill)
        .clipped()
        .frame(width: 548, height: 548*9/16)
//        .overlay(
//            GeometryReader() { geo in
//                if item.userData!.playbackPosition != 0 {
//                    ZStack(alignment: .leading) {
//                        Capsule()
//                        Capsule()
//                            .fill(Color.green)
//                            .frame(width: (geo.size.width-40) * CGFloat(item.userData!.playbackPosition / item.runTime))
////                            .onAppear() {
////                                print("ITEM \(item.name) \n  RUNTIME: \(item.runTime) \n  POSITION: \(item.userData.playbackPosition) \n \((item.userData.playbackPosition / item.runTime)) \n  WIDTH: \((geo.size.width-40) * CGFloat(item.userData.playbackPosition / item.runTime))")
////                            }
//                    }.frame(height: 10).padding(20)
//                }
//            }.frame(width: 548)
//        , alignment: .bottom)
    }
}
