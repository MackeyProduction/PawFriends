//
//  MultiPickerTestView.swift
//  PawFriends
//
//  Created by Hanna Steffen on 02.07.24.
//

import SwiftUI
import MultiPicker

struct MultiPickerView: View {
    
    @State var selection = Set<String>()
    //let items = ["ok1", "ok2", "ok3", "ok4", "ok5"]
    let items: [String]
    let tags: [Tag]
    
    var body: some View {
        ForEach(tags, id: \.id) { tag in
            Text(tag.description ?? "")
                .tag(tag.description as String?)
        }
        
        VStack {
//            List(tags, id: \.id, selection: $selection) { tag in
////                Section {}
////                    .listSectionSpacing(5)
//                let sel = [Tag](selection)
//                Text(tag.description ?? "")
//                    .listRowBackground(sel.contains(tag) ? Color(greenColor!) : nil)
//            }
            List(items, id: \.self, selection: $selection) { i in
//                Section {}
//                    .listSectionSpacing(5)
                let sel = [String](selection)
                Text(i)
                    .listRowBackground(sel.contains(i) ? Color(greenColor!) : nil)
            }
            .environment(\.editMode, .constant(EditMode.active))
            .scrollContentBackground(.hidden)
            //.border(.red)
            
            VStack {
                let tags = [String](selection)
                TagCloudView(tags: tags)
                    .padding(10)
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("Hinzufügen")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color(mainColor!))
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(greenColorReverse!)))
                })
            }
        }.background(Color(mainColor!))

    }
}


#Preview {
    MultiPickerView(items: ["ok1", "ok2", "ok3", "ok4", "ok5"], tags: [])
}
