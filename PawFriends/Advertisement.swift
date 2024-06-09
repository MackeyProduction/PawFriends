//
//  Advertisement.swift
//  PawFriends
//
//  Created by Til Anheier on 29.05.24.
//

import Foundation
import SwiftData

@Model
final class Advertisement {
    var title: String
    var timestamp: Date
    
    init(title: String, timestamp: Date) {
        self.title = title
        self.timestamp = timestamp
    }
}
