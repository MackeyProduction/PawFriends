//
//  FavoriteView.swift
//  PawFriends
//
//  Created by Til Anheier on 31.05.24.
//

import SwiftUI

struct FavoriteView: View {
    var body: some View {
        NavigationSplitView {
            FavoriteList()
        } detail: {
            Text("Select an item")
                .navigationTitle("Favoriten")
        }
    }
}

#Preview {
    FavoriteView()
        .modelContainer(for: Favorite.self, inMemory: true)
}
