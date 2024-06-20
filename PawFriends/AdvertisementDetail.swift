//
//  AdvertisementDetail.swift
//  PawFriends
//
//

import SwiftUI
<<<<<<< Updated upstream
import Amplify
import PhotosUI

struct AdvertisementDetail: View {
    @Binding var advertisement: Advertisement
    let isNew: Bool
    @State var selectedItems: [PhotosPickerItem] = []
    @State private var title: String = ""
    @State private var releaseDate: Date = Date()
=======
import SwiftData
import PhotosUI

struct AdvertisementDetail: View {
    @Query(sort: \Advertisement.title) private var ads: [Advertisement]
    @Bindable var advertisement: Advertisement
    let isNew: Bool
>>>>>>> Stashed changes
    
    @StateObject private var viewModel = PhotoPickerViewModel()
    @State var imageSelections: [PhotosPickerItem] = []


    @Environment(\.dismiss) private var dismiss
    
    init(advertisement: Binding<Advertisement>, isNew: Bool = false) {
        self._advertisement = advertisement
        self.isNew = isNew
        self.selectedItems = []
        self.title = ""
        self.releaseDate = Date()
    }
    
    func dataToUiimages(data: [Data]) -> [UIImage]{
        var uiimages: [UIImage] = []
        for image in data {
            uiimages.append(UIImage(data: image)!)
        }
        return uiimages
    }
    
    func getTimestamp(timestamp: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let dateString = formatter.string(from: timestamp)
        return dateString
    }
    
    var body: some View {
    
        VStack(spacing: 10) {
            //Image("TestImage2")
            if isNew {
                if !viewModel.selectedImages.isEmpty {
                    //            Image(systemName: "photo")
                    //                .resizable()
                    //                .scaledToFill()
                    //                .frame(maxWidth: .infinity, maxHeight: 250, alignment: .leading)
                    //                .clipped()
                    SliderView(images: viewModel.selectedImages)
                        .overlay(alignment: .bottomTrailing) {
                            PhotosPicker(selection: $viewModel.imageSelections,
                                         matching: .images,
                                         photoLibrary: .shared()) {
                                PickPhotoButton()
                                    .padding(.bottom, 5)
                                    .padding(.trailing, 5)
                            }
                                         .buttonStyle(.borderless)
                        }
                }
                //                ScrollView(.horizontal, showsIndicators: false) {
                //                    HStack {
                //                        ForEach(viewModel.selectedImages, id: \.self) { image in
                //                            Image(uiImage: image)
                //                                .resizable()
                //                                .scaledToFill()
                //                                .frame(width: 60, height: 60)
                //                                .cornerRadius(10)
                //                        }
                //                    }
                //                }
                
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: 250, alignment: .center)
                    .clipped()
                    .opacity(0.2)
                    .overlay(alignment: .bottomTrailing) {
                        PhotosPicker(selection: $viewModel.imageSelections,
                                     matching: .images,
                                     photoLibrary: .shared()) {
                            PickPhotoButton()
                                .padding(.bottom, 5)
                                .padding(.trailing, 5)
                        }
                                     .buttonStyle(.borderless)
                    }
<<<<<<< Updated upstream
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
=======
            } else {
                if ads[0].images != nil {
                    SliderView(images: dataToUiimages(data: ads[0].images!))
                        .overlay(alignment: .topTrailing) {
                            LikeAndShare(color: Color.white)
                        }
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: 250, alignment: .center)
                        .clipped()
                        .opacity(0.2)
                        .overlay(alignment: .topTrailing) {
                            LikeAndShare(color: Color.black)
                        }
                }
            }
            
            Text(ads[0].title)
                .font(.title)
                .fontWeight(.semibold)
                .multilineTextAlignment(.leading)
            HStack {
                Text("Ort")
                    .padding(.leading)
                Spacer()
                Text(getTimestamp(timestamp: ads[0].timestamp))
                    .padding(.trailing)
            }
            
            
            if isNew {
                Form {
                    TextField("Anzeige Titel", text: $advertisement.title)
                    
                    DatePicker("Veröffentlichungsdatum", selection: $advertisement.timestamp, displayedComponents: .date)
                }
                .toolbar {
                    //if isNew {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            dismiss()
                        }
>>>>>>> Stashed changes
                    }
                    
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            modelContext.delete(advertisement)
                            dismiss()
                        }
                    }
                    //}
                }
            }
            
            //.navigationTitle(isNew ? "Neue Anzeige" : "Anzeige")
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
    }
    
    private func saveAdvertisement() {
        advertisement.title = title.isEmpty ? nil : title
        advertisement.releaseDate = Temporal.DateTime(releaseDate)
    }
}



struct LikeAndShare: View
{
    var color: Color = Color.white

    var body: some View {

        HStack {
            FittedImage(imageName: "heart", width: 25, height: 25)
                .padding(.trailing, 5)
                .foregroundStyle(color)
            FittedImage(imageName: "square.and.arrow.up", width: 30, height: 30)
                .padding(.bottom, 5)
                .foregroundStyle(color)
        }
        .padding(.trailing, 10)
        .padding(.top, 5)
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



