//
//  FollowingListView.swift
//  PawFriends
//
//  Created by Til Anheier on 23.06.24.
//

import SwiftUI

struct FollowingListView: View {
    @StateObject var userProfileViewModel: UserProfileViewModel
    @State private var followList: [UserProfile] = []
    
    var body: some View {
        if let follows = userProfileViewModel.userProfile?.follows, follows.isLoaded, !follows.isEmpty {
            List {
                ForEach($followList, id: \.id) { user in
                    NavigationLink(destination: ProfileView(userProfileViewModel: userProfileViewModel)) {
                        HStack {
                            Image("TestImage1")
                                .resizable()
                                .frame(width: 50, height: 50)
                            VStack(alignment: .leading) {
                                Text(user.wrappedValue.author ?? "Benutzer nicht gefunden")
                                    .font(.headline)
                                Text(user.wrappedValue.location ?? "Ort nicht gefunden")
                                    .font(.subheadline)
                            }
                            Spacer()
                            Button(action: {
                                //                            if let index = people.firstIndex(where: { $0.id == person.id }) {
                                //                                people.remove(at: index)
                                //                            }
                            }) {
                                Text("Entfolgen")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
            }
            .onAppear {
                Task {
                    do {
                        try await userProfileViewModel.userProfile?.follows?.fetch()
                        self.followList = await getFollows(followList: userProfileViewModel.userProfile?.follows?.elements ?? [])
                    }
                }
            }
        } else {
            ContentUnavailableView {
                Label("Keine Follower gefunden", systemImage: "person")
            }
        }
    }
    
    func getFollows(followList: [UserProfileFollower]) async -> [UserProfile] {
        do {
            self.followList = []
            for item in followList {
                let followed = try await item.followed!
                
                self.followList.append(followed)
            }
        } catch {
            print("Could not fetch data.")
        }
        
        return self.followList
    }
}

#Preview {
    FollowingListView(userProfileViewModel: UserProfileViewModel(userProfile: UserProfileViewModel.sampleData[0]))
}
