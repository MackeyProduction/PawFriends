//
//  SwipeView.swift
//  PawFriends
//
//  Created by Hanna Steffen on 22.06.24.
//
import SwiftUI

struct SwipeView: View {
    var images: [UIImage]
    @State private var currentIndex: Int = 0
        
        var body: some View {
            TabView(selection: $currentIndex) {
                ForEach(0..<images.count, id: \.self) { index in
                    Image(uiImage: images[index])
                        .resizable()
                        .scaledToFit()
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            .gesture(DragGesture().onEnded { gesture in
                if gesture.translation.width < 0 {
                    // Swiped left
                    currentIndex = min(currentIndex + 1, images.count - 1)
                } else {
                    // Swiped right
                    currentIndex = max(currentIndex - 1, 0)
                }
            })
            .frame(maxWidth: .infinity, maxHeight: 275, alignment: .top)
        }
}

struct SliderView: View
{
    let images: [UIImage]
    
    var body: some View {
        ZStack(alignment: .top) {
            TabView {
                ForEach(images, id: \.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 340, alignment: .top) // Set a fixed height for the image
                        .clipped()
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .frame(maxWidth: .infinity, maxHeight: 275, alignment: .top)
            .edgesIgnoringSafeArea(.top) // Ignore safe area to align at the top
            .border(Color.red)
        }
    }
}
