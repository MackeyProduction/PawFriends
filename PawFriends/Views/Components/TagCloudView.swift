//
//  TagCloudView.swift
//  PawFriends
//
//  Created by Hanna Steffen on 22.06.24.
//

import SwiftUI

struct TagCloudView: View {
    var tags: [String]

    @State private var totalHeight
          = CGFloat.zero       // << variant for ScrollView/List
    //    = CGFloat.infinity   // << variant for VStack

    var body: some View {
        VStack {
            GeometryReader { geometry in
                self.generateContent(in: geometry)
            }
        }
        .frame(height: totalHeight)// << variant for ScrollView/List
        //.frame(maxHeight: totalHeight) // << variant for VStack
        
//        WrappingHStack {
//            Text("WrappingHStack")
//                .padding()
//                .font(.title)
//                .border(Color.black)
//            
//            Text("can handle different element types")
//            
//            Image(systemName: "scribble")
//                .font(.title)
//                .frame(width: 200, height: 20)
//                .background(Color.purple)
//            
//            Text("and loop")
//                .bold()
//            
//            WrappingHStack(1...20, id:\.self) {
//                Text("Item: \($0)")
//                    .padding(3)
//                    .background(Rectangle().stroke())
//            }.frame(minWidth: 250)
//        }
//        .padding()
//        .border(Color.black)
    }

    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(self.tags, id: \.self) { tag in
                self.item(for: tag)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width)
                        {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if tag == self.tags.last! {
                            width = 0 //last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        let result = height
                        if tag == self.tags.last! {
                            height = 0 // last item
                        }
                        return result
                    })
            }
        }.background(viewHeightReader($totalHeight))
    }

    private func item(for text: String) -> some View {
        Text(text)
            .font(.subheadline)
            .padding(.all, 5)
            .padding(.leading, 2)
            .padding(.trailing, 2)
            .font(.body)
            .background(Color(greenColor!))
            .cornerRadius(10)
//        Text(text)
//            .font(.subheadline)
//            .fixedSize(horizontal: true, vertical: false)
//            .multilineTextAlignment(.center)
//            .padding()
//            .frame(maxWidth: .infinity, maxHeight: 35)
//            .background(RoundedRectangle(cornerRadius: 10).fill(Color.black).opacity(0.4))
    }

    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
}

struct TestTagCloudView : View {
    var body: some View {
        VStack {
            Text("Header").font(.largeTitle)
            TagCloudView(tags: ["Ninetendo", "XBox", "PlayStation", "PlayStation 2", "PlayStation 3", "PlayStation 4"])
            Text("Some other text")
            Divider()
            Text("Some other cloud")
            TagCloudView(tags: ["Apple", "Google", "Amazon", "Microsoft", "Oracle", "Facebook"])
        }
    }
}

#Preview {
    TagCloudView(tags: ["Ninetendo", "XBox", "PlayStation", "PlayStation 2", "PlayStation 3", "PlayStation 4"])
        .background(Color.gray)
}
