//
//  NumberFormatHelper.swift
//  PawFriends
//
//  Created by Til Anheier on 05.07.24.
//

import Foundation

struct NumberFormatHelper {
    // Auf Basis von: https://letscode.thomassillmann.de/textfeld-auf-basis-von-zahlenwerten-in-swiftui/
    static var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter
    }
}
