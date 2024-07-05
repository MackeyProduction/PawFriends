//
//  SettingsView.swift
//  PawFriends
//
//  Created by Hanna Steffen on 30.06.24.
//

import SwiftUI
import Authenticator

struct SettingsView: View {
    @State private var navigateToContentView = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Einstellungen")
                    .font(.title)
                    .fontWeight(.medium)
            }
            List {
                Section {
                    Authenticator() { state in
                        Button("Abmelden", systemImage: "rectangle.portrait.and.arrow.right") {
                            Task {
                                navigateToContentView = true
                                await state.signOut()
                            }
                        }.navigationDestination(isPresented: $navigateToContentView) {
                            ContentView(userProfileViewModel: UserProfileViewModel(userProfile: UserProfileViewModel.sampleData[0]), advertisementViewModel: AdvertisementViewModel(advertisements: AdvertisementViewModel.sampleData))
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .listRowSpacing(10)
            .frame( maxWidth: .infinity)
        }
        .background(Color(mainColor!))
    }
}

#Preview {
    SettingsView()
}
