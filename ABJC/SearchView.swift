//
//  SearchView.swift
//  ABJC (ATV)
//
//  Created by Noah Kamara on 30.10.20.
//

import SwiftUI
import abjc_core
import JellyKit

struct SearchView: View {
    @EnvironmentObject var session: SessionStore
    @State var query: String = ""
    
    @State var items: [API.Models.Item] = []
    @State var people: [API.Models.Person] = []
    
    var body: some View {
        NavigationView {
            ScrollView([.vertical]) {
                TextField("search.label", text: $query, onCommit: search)
                    .padding(.horizontal, 80)
                LazyVStack(alignment: .leading) {
                    if items.count != 0 {
                        VStack(alignment: .leading, spacing: 10) {
                            ScrollView([.horizontal]) {
                                LazyHGrid(rows: [GridItem(.fixed(548*9/16)), GridItem(.fixed(548*9/16))], spacing: 48) {
                                    ForEach(items, id:\.id) { item in
                                        NavigationLink(destination: ItemDetailView(item)) {
                                            MediaItem(item)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }.edgesIgnoringSafeArea(.horizontal)
                                .padding(.leading, 80)
                                .padding(.bottom, 60)
                                .padding(.top, 20)
                            }
                        }
                    }
                    
                    if people.count != 0 {
                        Divider()
                        Text("search.people.label").font(.title3)
                            .padding(.horizontal, 80)
                        ScrollView([.horizontal]) {
                            LazyHStack(spacing: 48) {
                                ForEach(people, id:\.id) { person in
                                    NavigationLink(destination: Text(person.name)) {
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
            }.edgesIgnoringSafeArea(.horizontal)
        }.edgesIgnoringSafeArea(.horizontal)

    }
    
    func search() {
        session.api.searchItems(query) { result in
            switch result {
            case .success(let items): self.items = items
            case .failure(let error): print(error)
            }
        }
        session.api.searchPeople(query) { result in
            switch result {
            case .success(let items): self.people = items
            case .failure(let error): print(error)
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
