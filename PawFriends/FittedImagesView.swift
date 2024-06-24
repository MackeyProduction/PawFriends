//
//  FittedImagesView.swift
//  PawFriends
//
//  Created by Hanna Steffen on 15.06.24.
//

import SwiftUI

struct FittedImage: View
{
    let imageName: String
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        VStack {
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .frame(width: width, height: height)
    }
}

struct FittedImagesView: View
{
    private let _name = "checkmark"

    var body: some View {

        VStack {

            FittedImage(imageName: "gamecontroller", width: 50, height: 50)
            .background(Color.yellow)

            FittedImage(imageName: _name, width: 100, height: 50)
            .background(Color.yellow)

            FittedImage(imageName: _name, width: 50, height: 100)
            .background(Color.yellow)

            FittedImage(imageName: _name, width: 100, height: 100)
            .background(Color.yellow)

        }
    }
}

#Preview {
    FittedImagesView()
}
