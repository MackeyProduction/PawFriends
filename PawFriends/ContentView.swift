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
            
            FavoriteView()
                .tabItem {
                    Label("Favoriten", systemImage: "heart")
                }
            
            MessageView()
                .tabItem {
                    Label("Nachrichten", systemImage: "message")
                }
            
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
