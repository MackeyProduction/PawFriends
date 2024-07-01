//
//  FavoriteList.swift
//  PawFriends
//
//  Created by Til Anheier on 09.06.24.
//

import SwiftUI
import SlidingTabView

struct FavoriteList: View {
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    @State private var selectedTabIndex = 0
    
    var body: some View {
        VStack {
            SlidingTabView(selection: self.$selectedTabIndex, tabs: ["Merkliste", "Folge ich"])
            
            if selectedTabIndex == 0 {
                WatchlistView(userProfileViewModel: userProfileViewModel)
            } else {
                FollowingListView(userProfileViewModel: userProfileViewModel)
            }
            
            Spacer()
        }
        .background(Color(mainColor!))
        .navigationTitle("Favoriten")
    }
}

#Preview {
    FavoriteList(userProfileViewModel: UserProfileViewModel(userProfile: UserProfileViewModel.sampleData[0]))
}
