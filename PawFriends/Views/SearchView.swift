//
//  SearchView.swift
//  PawFriends
//
//  Created by Til Anheier on 29.05.24.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var vm: UserProfileViewModel
    @ObservedObject var advertisementViewModel: AdvertisementViewModel
    @State private var searchText = ""

    var body: some View {
        NavigationSplitView {
            AdvertisementList(vm: vm, advertisementViewModel: advertisementViewModel, titleFilter: searchText)
                .searchable(text: $searchText)
        } detail: {
            Text("Select an item")
                .navigationTitle("Suche")
        }
    }
}

#Preview {
    SearchView(vm: UserProfileViewModel(userProfile: UserProfileViewModel.sampleData[0]), advertisementViewModel: AdvertisementViewModel(advertisements: AdvertisementViewModel.sampleData))
}
