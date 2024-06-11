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
    
    static let sampleData = [
        Advertisement(title: "Anzeige 1",
                      timestamp: Date(timeIntervalSinceReferenceDate: -402_000_000)),
        Advertisement(title: "Anzeige 2",
              timestamp: Date(timeIntervalSinceReferenceDate: -20_000_000))
    ]
}
