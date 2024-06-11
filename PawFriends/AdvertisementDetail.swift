//
//  AdvertisementDetail.swift
//  PawFriends
//
//

import SwiftUI
import PhotosUI

struct AdvertisementDetail: View {
    @Bindable var advertisement: Advertisement
    let isNew: Bool
    @State var selectedItems: [PhotosPickerItem] = []
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    init(advertisement: Advertisement, isNew: Bool = false) {
        self.advertisement = advertisement
        self.isNew = isNew
    }
    
    
    var body: some View {
        Image("TestImage2")
            .resizable()
            .scaledToFill()
            .frame(width: 400, height: 300, alignment: .leading)
            .clipped()
        
        HStack{
            FittedImage(imageName: "camera.badge.ellipsis", width: 40, height: 40)
            PhotosPicker(selection: $selectedItems,
                                 matching: .images) {
                        Text("Bilder hinzufügen")
                    }
        }
        
        Form {
            TextField("Anzeige Titel", text: $advertisement.title)
            
            DatePicker("Veröffentlichungsdatum", selection: $advertisement.timestamp, displayedComponents: .date)
        }
        .navigationTitle(isNew ? "Neue Anzeige" : "Anzeige")
        .toolbar {
            if isNew {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        modelContext.delete(advertisement)
                        dismiss()
                    }
                }
            }
        }
    }
}


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
    NavigationStack {
        AdvertisementDetail(advertisement: SampleData.shared.advertisement)
    }
    .modelContainer(SampleData.shared.modelContainer)
}

#Preview("New Movie") {
    NavigationStack {
        AdvertisementDetail(advertisement: SampleData.shared.advertisement, isNew: true)
            .navigationBarTitleDisplayMode(.inline)
    }
    .modelContainer(SampleData.shared.modelContainer)
    
}
