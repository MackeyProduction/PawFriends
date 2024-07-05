//
//  UIImageHelper.swift
//  PawFriends
//
//  Created by Til Anheier on 05.07.24.
//

import Foundation
import SwiftUI
import PhotosUI

struct UIImageHelper {
    static func stringToUiimages(strings: [String?]?) -> [UIImage]{
        var uiimages: [UIImage] = []
        for string in strings! {
            let image: Image = Image(string!)
            uiimages.append(image.asUIImage())
        }
        return uiimages
    }
}
