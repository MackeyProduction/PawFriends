//
//  ContentView.swift
//  PawFriends
//
//  Created by Til Anheier on 31.05.24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            SearchView()
                .tabItem {
                    Label("Suche", systemImage: "magnifyingglass")
                }
                .modelContainer(for: Advertisement.self, inMemory: true)
            
            FavoriteView()
                .tabItem {
                    Label("Favoriten", systemImage: "heart")
                }
                .modelContainer(for: Favorite.self, inMemory: true)
            
            MessageView()
                .tabItem {
                    Label("Nachrichten", systemImage: "message")
                }
                .modelContainer(for: Message.self, inMemory: true)
            
            ProfileView()
                .tabItem {
                    Label("Profil", systemImage: "person")
                }
        }
    }
}

#Preview {
    ContentView()
}
