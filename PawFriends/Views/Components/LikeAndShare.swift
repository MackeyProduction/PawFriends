//
//  LikeAndShare.swift
//  PawFriends
//
//  Created by Hanna Steffen on 22.06.24.
//

import SwiftUI

struct LikeAndShare: View
{
    var color: Color = Color.white
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(width: 75, height: 35)
            .foregroundStyle(.black)
            .opacity(0.4)
            .overlay(alignment: .center) {
                HStack {
                    FittedImage(imageName: "heart", width: 22, height: 22)
                        .padding(.trailing, 5)
                        .foregroundStyle(color)
                    FittedImage(imageName: "square.and.arrow.up", width: 25, height: 25)
                        .padding(.bottom, 5)
                        .foregroundStyle(color)
                }
            }

    }
}

#Preview {
    LikeAndShare()
}
