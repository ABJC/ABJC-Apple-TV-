//
//  PeopleItem.swift
//  ABJC (ATV)
//
//  Created by Noah Kamara on 28.10.20.
//

import SwiftUI
import JellyKit
import URLImage

struct PeopleItem: View {
    @EnvironmentObject var session: SessionStore
    var person: API.Models.Person
    
    public init(_ person: API.Models.Person) {
        self.person = person
    }
    
    public var body: some View {
        VStack {
            URLImage(
                url: session.api.getImageURL(for: person.id, .primary),
                options: URLImageOptions(
                    identifier: person.id+"Primary",
                    expireAfter: .infinity,
                    cachePolicy: .returnCacheReload(cacheDelay: 0.25, downloadDelay: 0.25)
                ),
                empty: { Circle() },
                inProgress: { progress in
                    Group {
                        if let progress = progress {
                            Circle().overlay(ProgressView(value: progress))
                        }
                        else {
                            Circle()
                        }
                    }
                },
                failure:  { _,_ in Circle() }
            ) { image in
                    image
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(alignment: .top)
            }
            .clipShape(Circle())
            .clipped()
            .frame(width: 300, height: 300)
            .padding([.horizontal, .top], 10)
            
            
            VStack {
                Text(person.name)
                Text(person.role ?? " ")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }.padding([.horizontal, .bottom], 10)
        }
    }
}
