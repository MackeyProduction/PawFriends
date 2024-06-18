//
//  SearchView.swift
//  PawFriends
//
//  Created by Til Anheier on 29.05.24.
//

import SwiftUI
import SwiftData

struct SearchView: View {
    @State private var searchText = ""

    var body: some View {
        NavigationSplitView {
            AdvertisementList(titleFilter: searchText)
                .searchable(text: $searchText)
        } detail: {
            Text("Select an item")
                .navigationTitle("Suche")
        }
    }
}

#Preview {
    SearchView()
}
