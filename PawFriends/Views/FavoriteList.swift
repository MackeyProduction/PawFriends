//
//  FavoriteList.swift
//  PawFriends
//
//  Created by Til Anheier on 09.06.24.
//

import SwiftUI
import SlidingTabView
import SwiftData

struct FavoriteList: View {
    
    @State private var selectedTabIndex = 0
    
    var body: some View {
        VStack {
            SlidingTabView(selection: self.$selectedTabIndex, tabs: ["Merkliste", "Folge ich"]).padding()
            
            if selectedTabIndex == 0 {
                WatchlistView()
            } else {
                FollowingListView()
            }
            
            Spacer()
        }
        .navigationTitle("Favoriten")
    }
}

#Preview {
    FavoriteList()
        .modelContainer(for: Favorite.self, inMemory: true)
}
