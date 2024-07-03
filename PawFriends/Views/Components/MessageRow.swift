//
//  MessageRow.swift
//  PawFriends
//
//  Created by Til Anheier on 23.06.24.
//

import SwiftUI
import Amplify

struct MessageRow: View {
    @Binding var chat: Chat
    
    var body: some View {
        HStack {
            Image("TestImage2")
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(truncatedMessage)
                    .font(.headline)
                Text("Last sender: \(chat.author ?? "")")
                    .font(.subheadline)
                Text("\(dateToString(date: chat.updatedAt ?? Temporal.DateTime.now()))")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.leading, 8)
        }
        .padding()
    }
    
    var truncatedMessage: String {
        let messageLimit = 40
        if let message = chat.message, message.count > messageLimit {
            var truncatedMessage = message
            let endIndex = message.index(message.startIndex, offsetBy: messageLimit)
            truncatedMessage.replaceSubrange(endIndex..<message.endIndex, with: "...")
            return truncatedMessage
        }
        return chat.message ?? ""
    }
    
    func dateToString(date: Temporal.DateTime) -> String {
        let relativeDateFormatter = DateFormatter()
        relativeDateFormatter.timeStyle = .none
        relativeDateFormatter.dateStyle = .medium
        relativeDateFormatter.locale = Locale(identifier: "de_DE")
        relativeDateFormatter.doesRelativeDateFormatting = true
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        let timeString = timeFormatter.string(from: date.foundationDate)
        let relativeDateString = relativeDateFormatter.string(from: date.foundationDate)
        let RelativeDateTimeString = relativeDateString+", "+timeString
        
        return RelativeDateTimeString
    }
}
