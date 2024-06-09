//
//  MessageList.swift
//  PawFriends
//
//  Created by Til Anheier on 09.06.24.
//

import SwiftUI
import SwiftData

struct MessageList: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var messages: [Message]
    
    var body: some View {
        Group {
            if !messages.isEmpty {
                List {
                    ForEach(messages) { message in
                        NavigationLink {
                            Text("Item at \(message.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                        } label: {
                            Text(message.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
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
}

#Preview {
    MessageList()
        .modelContainer(for: Message.self, inMemory: true)
}
