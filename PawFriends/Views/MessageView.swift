//
//  MessageView.swift
//  PawFriends
//
//  Created by Til Anheier on 31.05.24.
//

import SwiftUI

struct MessageView: View {
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    
    var body: some View {
        NavigationSplitView {
            MessageList(userProfileViewModel: userProfileViewModel)
        } detail: {
            Text("Select an item")
                .navigationTitle("Nachrichten")
        }
    }
}

#Preview {
    MessageView(userProfileViewModel: UserProfileViewModel(userProfile: UserProfileViewModel.sampleData[0]))
}
