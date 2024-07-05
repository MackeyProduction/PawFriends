//
//  ProfileAdvertisementSheet.swift
//  PawFriends
//
//  Created by Til Anheier on 28.06.24.
//

import SwiftUI
import PhotosUI

struct ProfileAdvertisementSheet: View {
    @ObservedObject var vm: UserProfileViewModel
    @ObservedObject var advertisementViewModel: AdvertisementViewModel
    @Binding var advertisement: Advertisement
    @State var isNew: Bool = false
    @State private var isShowingTagsSheet = false
    
    @StateObject private var photoPickerViewModel = PhotoPickerViewModel()
    @State var imageSelections: [PhotosPickerItem] = []
    
    @State private var navigateToMultiPickerView = false
    
    @State private var tagCloud: [String] = []
    
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
                    TextField("Titel", text: Binding(
                        get: { advertisement.title ?? "" },
                        set: { advertisement.title = $0 }
                    ), axis: .vertical)
                        .autocorrectionDisabled()
                }
                .listRowBackground(Color(thirdColor!))
                
                Section {
                    HStack {
                        Text("Tags")
                        Spacer()
                        Button(action: { isShowingTagsSheet.toggle() }) {
                            Image(systemName: "plus.square")
                                .font(.title2)
                        }
                        .sheet(isPresented: $isShowingTagsSheet) {
                            NavigationStack {
                                MultiPickerView(advertisementViewModel: advertisementViewModel, advertisement: $advertisement, isAdvertisement: true)
                            }
                        }
                    }
                    
                    VStack {
                        TagCloudView(tags: tagCloud)
                    }
                }
                .listRowBackground(Color(thirdColor!))
                
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
    
    private func loadTagCloud() async throws {
        do {
            let tagItems = advertisement.tags?.elements
            for item in tagItems! {
                let tag = try await item.tag
                self.tagCloud.append(tag?.description ?? "")
            }
        } catch {
            print("Could not fetch tags for tag cloud.")
        }
    }
    
    private func createOrUpdate() {
        Task {
            do {
                // check if we have a new or an existing advertisement
                if isNew {
                    await vm.createAdvertisement(userProfile: vm.userProfile!, advertisement: advertisement)
                } else {
                    await vm.updateAdvertisement(userProfile: vm.userProfile!, advertisement: advertisement)
                }
                
                // reload advertisements
                await vm.fetchAdvertisements(userProfile: vm.userProfile!)
                
                dismiss()
            }
        }
    }
}

#Preview {
    NavigationStack {
        @State var advertisement = UserProfileViewModel.sampleData[0].advertisements?.first ?? Advertisement()
        ProfileAdvertisementSheet(vm: UserProfileViewModel(userProfile: UserProfileViewModel.sampleData[0]), advertisementViewModel: AdvertisementViewModel(advertisements: AdvertisementViewModel.sampleData), advertisement: $advertisement)
    }
}
