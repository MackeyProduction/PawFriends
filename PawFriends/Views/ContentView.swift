//
//  ContentView.swift
//  PawFriends
//
//  Created by Til Anheier on 31.05.24.
//

import Amplify
import Authenticator
import SwiftUI

let mainColor = UIColor(named: "MainColor")
let firstColor = UIColor(named: "FirstColor")
let secondColor = UIColor(named: "SecondColor")
let thirdColor = UIColor(named: "ThirdColor")
let textColor = UIColor(named: "TextColor")
let mainTextColor = UIColor(named: "MainTextColor")
let greenColor = UIColor(named: "GreenColor")
let greenColorReverse = UIColor(named: "GreenColorReverse")

struct ContentView: View {
    @StateObject private var userProfileViewModel: UserProfileViewModel = UserProfileViewModel()
    @State private var userAttributes: [AuthUserAttribute] = []
    @State private var userId: String? = nil
    
    var body: some View {
        Authenticator(
            headerContent: {
                Image("PawFriendsLogo")
            }
        ) { state in
            VStack {
                AppView()
                
                Button("Sign out") {
                    Task {
                        await state.signOut()
                    }
                }
            }.onAppear {
                Task {
                    self.userAttributes = await userProfileViewModel.fetchAttributes()
                    self.userId = self.userAttributes.first(where: { $0.key.rawValue == "sub" })?.value
                    
                    if let uId = userId, let uuid = UUID(uuidString: uId) {
                        await userProfileViewModel.createProfile(userProfile: UserProfile(id: uuid.uuidString, userProfileId: uuid.uuidString))
                    }
                }
            }
        }.signUpFields([
            .email(),
            .text(
                key: .preferredUsername,
                label: "Username",
                placeholder: "Enter your username",
                isRequired: true
            ),
            .password()
        ])
    }
}

struct AppView: View {
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
            
            ProfileView(advertisementArray: [])
                .tabItem {
                    Label("Profil", systemImage: "person")
                }
        }
    }
}

#Preview {
    ContentView()
}

#Preview("ContentView:App") {
    AppView()
}
