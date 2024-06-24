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
    
    
//    @State private var currentIndex: Int = 0
//    @State private var offset: CGFloat = 0
//    @State private var dragOffset: CGFloat = 0
//    
//    var body: some View {
//        GeometryReader { geometry in
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack(spacing: 0) {
//                    ForEach(images.indices, id: \.self) { index in
//                        Image(uiImage: images[index])
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: geometry.size.width, height: geometry.size.height)
//                    }
//                }
//                .offset(x: offset + dragOffset)
//                .gesture(
//                    DragGesture()
//                        .onChanged { value in
//                            dragOffset = value.translation.width
//                        }
//                        .onEnded { value in
//                            let screenWidth = geometry.size.width
//                            let swipeThreshold: CGFloat = 50
//                            
//                            if value.predictedEndTranslation.width < -swipeThreshold {
//                                currentIndex = min(currentIndex + 1, images.count - 1)
//                            } else if value.predictedEndTranslation.width > swipeThreshold {
//                                currentIndex = max(currentIndex - 1, 0)
//                            }
//                            
//                            withAnimation {
//                                offset = -CGFloat(currentIndex) * screenWidth
//                            }
//                            
//                            dragOffset = 0
//                        }
//                )
//            }
//            .frame(maxWidth: .infinity, maxHeight: 300)
//        }
//        //.edgesIgnoringSafeArea(.all)
//    }
}

struct SliderView: View
{
    let images: [UIImage]
    //@State public var tabViewSelection = 0
    
    var body: some View {
//        var singleTabWidth = UIScreen.main.bounds.width / Double(images.count)
//
//        ZStack(alignment: .bottomLeading) {
//                    TabView(selection: $tabViewSelection) {
//                        ForEach(images, id: \.self){ image in
//                            Image(uiImage: image)
//                                .resizable()
//                                .scaledToFill()
//                                .frame(maxWidth: .infinity, maxHeight: 250, alignment: .leading)
//                                .clipped()
//                                .tabItem {
//                                    VStack {
//                                        //Image(systemName: "circle.fill")
//                                        TabIcon(icon: image)
//                                    }
//                                }
//                        }
//                    }
//
//                    Rectangle()
//                        .offset(x: singleTabWidth * CGFloat(tabViewSelection))
//                        .frame(width: singleTabWidth, height: 7)
//                        .padding(.bottom, 2)
//                        .animation(Animation.default, value: UUID())
//                }
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
            //.indexViewStyle(.page(backgroundDisplayMode: .always))
            .frame(maxWidth: .infinity, maxHeight: 275, alignment: .top)
            .edgesIgnoringSafeArea(.top) // Ignore safe area to align at the top
            .border(Color.red)
        }
    }
}
