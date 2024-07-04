//
//  MessageList.swift
//  PawFriends
//
//  Created by Til Anheier on 09.06.24.
//

import SwiftUI
import Amplify

struct MessageList: View {
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    @State private var chats: [String: [Chat]] = [:]
    
    var body: some View {
        Group {
            if !chats.isEmpty {
                List {
                    ForEach(chats.keys.sorted(), id: \.self) { key in
                        if let chatList = chats[key]?.sorted(by: { $0.updatedAt! < $1.updatedAt! }), let lastChat = chatList.last {
                            NavigationLink(destination: MessageDetail(vm: userProfileViewModel, chats: Binding.constant(chatList))) {
                                MessageRow(chat: Binding.constant(lastChat))
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            } else {
                ContentUnavailableView {
                    Label("Keine Nachrichten vorhanden", systemImage: "message")
                }
            }
        }
        .background(Color(mainColor!))
        .navigationTitle("Nachrichten")
        .onReceive(userProfileViewModel.$userProfile, perform: { _ in
            Task {
                do {
                    try await userProfileViewModel.userProfile?.advertisements?.fetch()
                    try await userProfileViewModel.userProfile?.chats?.fetch()
                    self.chats = try await filteredChats
                }
            }
        })
    }
    
    var filteredChats: [String: [Chat]] {
        get async throws {
            var filteredChats: [String: [Chat]] = [:]
            
            let chats = await userProfileViewModel.fetchChats(userProfile: userProfileViewModel.userProfile!)
            for chat in chats {
                if let ad = try await chat.advertisement {
                    filteredChats[ad.id] = await userProfileViewModel.fetchChatsByAdvertisement(advertisement: ad)
                }
            }
            
            return filteredChats
        }
    }

}

#Preview {
    MessageList(userProfileViewModel: UserProfileViewModel(userProfile: UserProfileViewModel.sampleData[0]))
}
