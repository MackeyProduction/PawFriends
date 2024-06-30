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
    @StateObject var userProfileViewModel: UserProfileViewModel
    @StateObject var advertisementViewModel: AdvertisementViewModel
    @State private var userAttributes: [AuthUserAttribute] = []
    @State private var userId: String? = nil
    
    var body: some View {
        Authenticator(
            headerContent: {
                Image("PawFriendsLogo")
            }
        ) { state in
            VStack {
                AppView(userProfileViewModel: userProfileViewModel, advertisementViewModel: advertisementViewModel)
                
                Button("Sign out") {
                    Task {
                        await state.signOut()
                    }
                }
            }.onAppear {
                Task {
                    if !ProcessInfo.processInfo.isSwiftUIPreview {
                        await userProfileViewModel.getCurrentProfile()
                        
                        self.userAttributes = await userProfileViewModel.fetchAttributes()
                        self.userId = self.userAttributes.first(where: { $0.key.rawValue == "sub" })?.value
                        
                        if let uId = userId, let uuid = UUID(uuidString: uId) {
                            await userProfileViewModel.createProfile(userProfile: UserProfile(id: uuid.uuidString, userProfileId: uuid.uuidString, description: "", activeSince: Temporal.Date.now(), location: ""))
                        }
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
    @StateObject var userProfileViewModel: UserProfileViewModel
    @StateObject var advertisementViewModel: AdvertisementViewModel
    
    var body: some View {
        TabView {
            SearchView(advertisementViewModel: advertisementViewModel)
                .tabItem {
                    Label("Suche", systemImage: "magnifyingglass")
                }
            
            FavoriteView(userProfileViewModel: userProfileViewModel)
                .tabItem {
                    Label("Favoriten", systemImage: "heart")
                }
            
            MessageView(userProfileViewModel: userProfileViewModel)
                .tabItem {
                    Label("Nachrichten", systemImage: "message")
                }
            
            ProfileView(userProfileViewModel: userProfileViewModel)
                .tabItem {
                    Label("Profil", systemImage: "person")
                }
        }
    }
}

#Preview {
    ContentView(userProfileViewModel: UserProfileViewModel(userProfile: UserProfileViewModel.sampleData[0]), advertisementViewModel: AdvertisementViewModel(advertisements: AdvertisementViewModel.sampleData))
}

#Preview("ContentView:App") {
    AppView(userProfileViewModel: UserProfileViewModel(userProfile: UserProfileViewModel.sampleData[0]), advertisementViewModel: AdvertisementViewModel(advertisements: AdvertisementViewModel.sampleData))
}
