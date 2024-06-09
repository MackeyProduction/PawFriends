//
//  ProfileView.swift
//  PawFriends
//
//  Created by Til Anheier on 31.05.24.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationSplitView {
            Group {
                Text("Hello, this is the profile view.")
            }
            .navigationTitle("Profil")
        } detail: {
            Text("Select an item")
                .navigationTitle("Profil")
        }
    }
}

#Preview {
    ProfileView()
}
