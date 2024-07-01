//
//  AdvertisementSheet.swift
//  PawFriends
//
//  Created by Til Anheier on 01.07.24.
//

import SwiftUI
import PhotosUI

struct AdvertisementSheet: View {
    @ObservedObject var advertisementViewModel: AdvertisementViewModel
    @StateObject private var photoPickerViewModel: PhotoPickerViewModel = PhotoPickerViewModel()
    @Binding var advertisement: Advertisement
    @State var isNew: Bool = false
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 10) {
            if photoPickerViewModel.selectedImages.isEmpty {
                ZStack {
                    Rectangle()
                        .fill(Color(secondColor!))
                        .frame(maxWidth: .infinity, maxHeight: 270)
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: 250, alignment: .center)
                        .clipped()
                        .foregroundStyle(Color(textColor!))
                        .opacity(0.2)
                        .overlay(alignment: .bottomTrailing) {
                            PhotosPicker(selection: $photoPickerViewModel.imageSelections,
                                         matching: .images,
                                         photoLibrary: .shared()) {
                                PickPhotoButton()
                                    .padding(.bottom, 5)
                                    .padding(.trailing, 5)
                            }
                                         .buttonStyle(.borderless)
                        }
                }
                .frame(height: 270)
            } else {
                //SwipeView(images: viewModel.selectedImages)
                Image(uiImage: photoPickerViewModel.selectedImages[0])
                    .resizable()
                    .scaledToFill()
                    .frame(height: 270, alignment: .top)
                    .clipped()
                    .overlay(alignment: .bottomTrailing) {
                        PhotosPicker(selection: $photoPickerViewModel.imageSelections,
                                     matching: .images,
                                     photoLibrary: .shared()) {
                            PickPhotoButton()
                                .padding(.bottom, 5)
                                .padding(.trailing, 5)
                        }
                                     .buttonStyle(.borderless)
                    }
            }
            
            Form {
                Section {
                    //Text("Titel")
                    TextField("Titel", text: Binding(
                        get: { advertisement.title ?? "" },
                        set: { advertisement.title = $0 }
                    ), axis: .vertical)
                        .autocorrectionDisabled()
                }
                .listRowBackground(Color(thirdColor!))
                
    //            Section { //Multi select, Kategorien sortiert
    //                Picker("Tags", selection: $tags) {
    //                    ForEach(tagOptions, id: \.self) {
    //                        Text($0)
    //                    }
    //                }//.pickerStyle()
    //            }
    //            .listRowBackground(Color(thirdColor!))
                
                Section {
                    Text("Beschreibung")
                    TextField("", text: Binding(
                        get: { advertisement.description ?? "" },
                        set: { advertisement.description = $0 }
                    ), axis: .vertical)
                        .autocorrectionDisabled()
                        .lineLimit(9...9)
                }
                .listRowBackground(Color(thirdColor!))
                                    
                Section(footer:
                            HStack {
                    Spacer()
                    Button(action: createOrUpdate) {
                        Text("Veröffentlichen")
                            .font(.title2)
                            .foregroundStyle(Color(mainTextColor!))
                    }
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color(greenColor!)))
                    Spacer()
                }
                ) {
                    EmptyView()
                }
            }.scrollContentBackground(.hidden)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Abbrechen", action: { dismiss() })
                    }
                }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
        .background(Color(mainColor!))
        .edgesIgnoringSafeArea(.top)
    }
    
    private func createOrUpdate() {
        
    }
}

#Preview {
    NavigationStack {
        @State var advertisement = Advertisement()
        AdvertisementSheet(advertisementViewModel: AdvertisementViewModel(advertisements: AdvertisementViewModel.sampleData), advertisement: $advertisement)
    }
}
