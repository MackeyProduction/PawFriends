//
//  FollowProfileView.swift
//  PawFriends
//
//  Created by Til Anheier on 02.07.24.
//

import SwiftUI

struct FollowProfileView: View {
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    @State private var followedUserProfileViewModel: UserProfileViewModel? = nil
    @State var authorId: String? = nil
    
    var body: some View {
        ZStack {
            if let up = followedUserProfileViewModel, let author = authorId {
                ProfileView(userProfileViewModel: up, authorId: author, isMyProfile: false)
            }
        }
        .task {
            if let author = authorId, let uuid = UUID(uuidString: author) {
                let profile = await userProfileViewModel.getProfile(id: uuid)
                self.followedUserProfileViewModel = UserProfileViewModel(userProfile: profile)
            }
        }
    }
}

#Preview {
    FollowProfileView(userProfileViewModel: UserProfileViewModel(userProfile: UserProfileViewModel.sampleData[0]), authorId: "")
}
