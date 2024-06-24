//
//  MessageView.swift
//  PawFriends
//
//  Created by Til Anheier on 31.05.24.
//

import SwiftUI

struct MessageView: View {
    var body: some View {
        NavigationSplitView {
            MessageList()
        } detail: {
            Text("Select an item")
                .navigationTitle("Nachrichten")
        }
    }
}

#Preview {
    MessageView()
}
