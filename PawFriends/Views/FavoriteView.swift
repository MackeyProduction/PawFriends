//
//  FavoriteView.swift
//  PawFriends
//
//  Created by Til Anheier on 31.05.24.
//

import SwiftUI

struct FavoriteView: View {
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    
    var body: some View {
        NavigationSplitView {
            FavoriteList(userProfileViewModel: userProfileViewModel)            .background(Color(mainColor!))
        } detail: {
            Text("Select an item")
                .navigationTitle("Favoriten")
        }
    }

}

#Preview {
    FavoriteView(userProfileViewModel: UserProfileViewModel(userProfile: UserProfileViewModel.sampleData[0]))
}
