//
//  Favorite.swift
//  PawFriends
//
//  Created by Til Anheier on 09.06.24.
//

import Foundation
import SwiftData

@Model
final class Favorite {
    var title: String
    var timestamp: Date
    
    init(title: String, timestamp: Date) {
        self.title = title
        self.timestamp = timestamp
    }
}
