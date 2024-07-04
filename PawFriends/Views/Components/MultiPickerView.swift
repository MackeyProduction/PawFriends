//
//  MultiPickerTestView.swift
//  PawFriends
//
//  Created by Hanna Steffen on 02.07.24.
//

import SwiftUI
import MultiPicker
import Amplify

struct MultiPickerView: View {
    @ObservedObject var advertisementViewModel: AdvertisementViewModel = AdvertisementViewModel(advertisements: AdvertisementViewModel.sampleData)
    @ObservedObject var userProfileViewModel: UserProfileViewModel = UserProfileViewModel(userProfile: UserProfileViewModel.sampleData[0])
    @Binding var advertisement: Advertisement

    @Environment(\.dismiss) private var dismiss

    @State var isAdvertisement: Bool
    
    @State var selection = Set<String>()
    @State private var tag: String? = "tag"

    @State var items: [String] = []
    @State var tags: [Tag] = []
    @State var stringTags: [String] = []
    
    var body: some View {
        VStack {
            List(items, id: \.self, selection: $selection) { i in
                let sel = [String](selection)
                Text(i)
                    .listRowBackground(sel.contains(i) ? Color(greenColor!) : nil)
            }
            .environment(\.editMode, .constant(EditMode.active))
            .scrollContentBackground(.hidden)
            
            VStack {
                TagCloudView(tags: [String](selection))
                    .padding(10)
                
                Button(action: {
                    stringTags = [String](selection)
                    if isAdvertisement {
                        createOrUpdateAdvertisementTags()
                    } else {
                        createOrUpdateProfileTags()
                    }
                }, label: {
                    Text("Hinzufügen")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color(mainColor!))
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(greenColorReverse!)))
                })
            }
        }.background(Color(mainColor!))
        .onAppear {
            Task {
                if isAdvertisement {
                    self.tags = await advertisementViewModel.fetchTags()
                    try await advertisement.tags?.fetch()
                } else {
                    self.tags = await userProfileViewModel.fetchTags()
                }
                loadListItems()
            }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Abbrechen", action: { dismiss() })
            }
        }
    }
    
    private func loadListItems() {
        for tag in tags {
            self.items.append(tag.description ?? "")
        }
    }
    
    private func createOrUpdateAdvertisementTags() {
        do {
            Task {
                // load advertisement tags
                let advertisementTags = advertisement.tags?.elements
                
                if !stringTags.isEmpty  {
                    // check if advertisement tags exists, clear in database when tags exists
                    if let aTags = advertisementTags, !aTags.isEmpty {
                        await removeAdvertisementTags(advertisementTags: aTags)
                    }
                    
                    // add selected tags to the database
                    for tag in stringTags {
                        let selectedAdvertisementTag = tag
                        
                        // format to tag
                        guard let formattedTag = tags.first(where: { $0.description == selectedAdvertisementTag }) else {
                            print("Error while casting tag.")
                            return
                        }
                        
                        // add formatted tag to the database
                        await advertisementViewModel.createTag(advertisement: advertisement, tag: formattedTag)
                    }
                }
            }
        }
        dismiss()
    }
    
    private func createOrUpdateProfileTags() {
        do {
            Task {
                // load profile tags
                let profileTags = userProfileViewModel.userProfile?.tags?.elements
                
                if !stringTags.isEmpty  {
                    // check if profile tags exists, clear in database when tags exists
                    if let pTags = profileTags, !pTags.isEmpty {
                        await removeProfileTags(userProfileTags: pTags)
                    }
                    
                    // add selected tags to the database
                    for tag in stringTags {
                        let selectedProfileTag = tag
                        
                        // format to tag
                        guard let formattedTag = tags.first(where: { $0.description == selectedProfileTag }) else {
                            print("Error while casting tag.")
                            return
                        }
                        
                        // add formatted tag to the database
                        await userProfileViewModel.createTag(userProfile: userProfileViewModel.userProfile!, tag: formattedTag)
                    }
                }
            }
        }
        dismiss()
    }
    
    private func removeProfileTags(userProfileTags: [UserProfileTag]) async {
        for tag in userProfileTags {
            await userProfileViewModel.deleteTag(userProfileTag: tag)
        }
    }
    
    private func removeAdvertisementTags(advertisementTags: [AdvertisementTag]) async {
        for tag in advertisementTags {
            await advertisementViewModel.deleteTag(advertisementTag: tag)
        }
    }
    
}


#Preview {
    MultiPickerView(advertisementViewModel: AdvertisementViewModel(advertisements: AdvertisementViewModel.sampleData), advertisement: Binding.constant(Advertisement()), isAdvertisement: true)
}

#Preview("UserProfile") {
    MultiPickerView(userProfileViewModel: UserProfileViewModel(userProfile: UserProfileViewModel.sampleData[0]), advertisement: Binding.constant(Advertisement()), isAdvertisement: false)
}
