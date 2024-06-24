//
//  FavoriteList.swift
//  PawFriends
//
//  Created by Til Anheier on 09.06.24.
//

import SwiftUI
import SwiftData

struct FavoriteList: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var favorites: [Favorite]
    
    var body: some View {
        Group {
            if !favorites.isEmpty {
                List {
                    ForEach(favorites) { favorite in
                        NavigationLink {
                            Text("Item at \(favorite.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                        } label: {
                            Text(favorite.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                        }
                    }
                }
            } else {
                ContentUnavailableView {
                    Label("Keine Favoriten gefunden", systemImage: "heart")
                }
            }
        }
        .navigationTitle("Favoriten")
    }
}

#Preview {
    FavoriteList()
        .modelContainer(for: Favorite.self, inMemory: true)
}
