//
//  WatchlistView.swift
//  PawFriends
//
//  Created by Til Anheier on 23.06.24.
//

import SwiftUI
import SwiftData

struct WatchlistView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var favorites: [Favorite]
    
    var body: some View {
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
}

#Preview {
    WatchlistView()
        .modelContainer(for: Favorite.self, inMemory: true)
}
