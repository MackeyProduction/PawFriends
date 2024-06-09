//
//  Message.swift
//  PawFriends
//
//  Created by Til Anheier on 09.06.24.
//

import Foundation
import SwiftData

@Model
final class Message {
    var subject: String
    var sender: String
    var receiver: String
    var message: String
    var timestamp: Date
    
    init(subject: String, sender: String, receiver: String, message: String, timestamp: Date) {
        self.subject = subject
        self.sender = sender
        self.receiver = receiver
        self.message = message
        self.timestamp = timestamp
    }
}
