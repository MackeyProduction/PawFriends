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
    @State private var chats: [Chat] = []
    
    var body: some View {
        Group {
            if let chats = userProfileViewModel.userProfile?.chats, chats.isLoaded {
                List {
                    // TODO: Chats müssen nach den Anzeigen gefiltert werden
                    ForEach($chats, id: \.id) { chat in
                        NavigationLink(destination: MessageDetail(vm: userProfileViewModel, chats: $chats)) {
                            MessageRow(chat: chat)
                        }
                    }
                }
                .onAppear {
                    Task {
                        do {
                            try await userProfileViewModel.userProfile?.chats?.fetch()
                            self.chats = chats.elements // Synchronisieren der lokalen Chat-Liste
                        }
                    }
                }
            } else {
                ContentUnavailableView {
                    Label("Keine Nachrichten vorhanden", systemImage: "message")
                }
            }
        }
        .navigationTitle("Nachrichten")
        
    }
    
    var filteredChats: [Chat] {
        // Filterfunktion funktioniert nicht... erstmal weg gelassen
        get async throws {
            guard let chats = userProfileViewModel.userProfile?.chats else {
                return []
            }
            
            var filteredChats: [Chat] = []
            
            for chat in chats {
                do {
                    if let advertisement = try await chat._advertisement.get() {
                        if let _ = userProfileViewModel.userProfile?.chats?.first(where: { $0.id == advertisement.id }) {
                            filteredChats.append(chat)
                        }
                    }
                } catch {
                    print("Error fetching advertisement: \(error)")
                }
            }
            
            return filteredChats
        }
    }

}

#Preview {
    MessageList(userProfileViewModel: UserProfileViewModel(userProfile: UserProfileViewModel.sampleData[0]))
}
