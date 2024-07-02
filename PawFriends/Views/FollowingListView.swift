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
        Group {
            if let follows = userProfileViewModel.userProfile?.follows, follows.isLoaded, !follows.isEmpty {
                List {
                    ForEach($followList, id: \.id) { user in
                        NavigationLink(destination: FollowProfileView(userProfileViewModel: userProfileViewModel, authorId: user.wrappedValue.author ?? "")) {
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
                                Button(action: {}) {
                                    Text("Entfolgen")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        
                        
                    }
                }
            } else {
                ContentUnavailableView {
                    Label("Keine Follower gefunden", systemImage: "person")
                }
            }
        }
        .background(Color(mainColor!))
        .scrollContentBackground(.hidden)
        .onAppear {
            Task {
                do {
                    if let follows = userProfileViewModel.userProfile?.follows, follows.isLoaded {
                        self.followList = await getFollows(followList: userProfileViewModel.userProfile?.follows?.elements ?? [])
                    }
                    
                }
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
