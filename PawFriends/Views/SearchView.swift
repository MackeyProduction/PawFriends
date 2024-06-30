//
//  SearchView.swift
//  PawFriends
//
//  Created by Til Anheier on 29.05.24.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var advertisementViewModel: AdvertisementViewModel
    @State private var searchText = ""

    var body: some View {
        NavigationSplitView {
            AdvertisementList(advertisementViewModel: advertisementViewModel, titleFilter: searchText)
                .searchable(text: $searchText)
        } detail: {
            Text("Select an item")
                .navigationTitle("Suche")
        }
    }
}

#Preview {
    SearchView(advertisementViewModel: AdvertisementViewModel(advertisements: AdvertisementViewModel.sampleData))
}
