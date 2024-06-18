//
//  AdvertisementDetail.swift
//  PawFriends
//
//

import SwiftUI
import Amplify
import PhotosUI

struct AdvertisementDetail: View {
    @Binding var advertisement: Advertisement
    let isNew: Bool
    @State var selectedItems: [PhotosPickerItem] = []
    @State private var title: String = ""
    @State private var releaseDate: Date = Date()
    
    @Environment(\.dismiss) private var dismiss
    
    init(advertisement: Binding<Advertisement>, isNew: Bool = false) {
        self._advertisement = advertisement
        self.isNew = isNew
        self.selectedItems = []
        self.title = ""
        self.releaseDate = Date()
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
            TextField("Anzeige Titel", text: $title)
            
            DatePicker("Veröffentlichungsdatum", selection: $releaseDate, displayedComponents: .date)
        }
        .navigationTitle(isNew ? "Neue Anzeige" : "Anzeige")
        .toolbar {
            if isNew {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        saveAdvertisement()
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        //modelContext.delete(advertisement)
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func saveAdvertisement() {
        advertisement.title = title.isEmpty ? nil : title
        advertisement.releaseDate = Temporal.DateTime(releaseDate)
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
        @State var sampleAdvertisement = AdvertisementViewModel.sampleData()[0]
        
        AdvertisementDetail(advertisement: $sampleAdvertisement)
    }
}

#Preview("New Advertisement") {
    NavigationStack {
        @State var sampleAdvertisement = AdvertisementViewModel.sampleData()[0]
        
        AdvertisementDetail(advertisement: $sampleAdvertisement, isNew: true)
            .navigationBarTitleDisplayMode(.inline)
    }
    
}
