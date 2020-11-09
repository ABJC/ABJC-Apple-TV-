//
//  PeoplaRow.swift
//  ABJC (ATV)
//
//  Created by Noah Kamara on 28.10.20.
//

import SwiftUI
import abjc_core
import JellyKit
import URLImage

struct PeopleRow: View {
    @EnvironmentObject var session: SessionStore
    
    var people: [API.Models.Person]
    
    public init(_ people: [API.Models.Person]) {
        self.people = people
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Besetzung & Crew")
                .font(.title3)
                .padding(.horizontal, 80)
            ScrollView([.horizontal]) {
                LazyHStack(spacing: 48) {
                    ForEach(people, id:\.id) { person in
                        Button(action: {}) {
                            PeopleItem(person)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding().padding(.vertical, 50)
                    }
                }
                .padding(.leading, 80)
                .padding(.bottom, 60)
                .padding(.top, 20)
            }
        }
    }
}

struct PeopleRow_Previews: PreviewProvider {
    static var previews: some View {
        PeopleRow([])
    }
}
