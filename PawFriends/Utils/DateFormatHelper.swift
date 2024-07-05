//
//  DateFormatHelper.swift
//  PawFriends
//
//  Created by Til Anheier on 05.07.24.
//

import Foundation
import Amplify

struct DateFormatHelper {
    static func dateToString(date: Temporal.Date) -> String {
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
    
    static func dateTimeToString(date: Temporal.DateTime) -> String {
        return dateToString(date: Temporal.Date(date.foundationDate, timeZone: TimeZone.current))
    }
    
    static func releaseDateToString(releaseDate: Temporal.DateTime) -> String {
        let relativeDateFormatter = DateFormatter()
        relativeDateFormatter.timeStyle = .none
        relativeDateFormatter.dateStyle = .medium
        relativeDateFormatter.locale = Locale(identifier: "de_DE")
        relativeDateFormatter.doesRelativeDateFormatting = true
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "dd.MM.yyyy"
        
        return timeFormatter.string(from: releaseDate.foundationDate)
    }
}
