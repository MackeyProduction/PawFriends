//
//  MultiPickerTestView.swift
//  PawFriends
//
//  Created by Hanna Steffen on 02.07.24.
//

import SwiftUI
import MultiPicker

struct MultiPickerView: View {
    @ObservedObject var advertisementViewModel: AdvertisementViewModel = AdvertisementViewModel(advertisements: AdvertisementViewModel.sampleData)
    @ObservedObject var userProfileViewModel: UserProfileViewModel = UserProfileViewModel(userProfile: UserProfileViewModel.sampleData[0])

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
                //let advertisementTags = userProfileViewModel.userProfile?.tags?.elements
                let advertisementTags = advertisementViewModel.advertisement?.tags?.elements
                
                if !stringTags.isEmpty  {
                    for tag in stringTags {
                        let selectedAdvertisementTag = tag
                        // format to tag
                        let formattedTag = tags.first(where: { $0.description == selectedAdvertisementTag })
                        
                        // check if advertisement tags exists
                        if let aTags = advertisementTags, aTags.isEmpty {
                            await advertisementViewModel.createTag(advertisement: advertisementViewModel.advertisement!, tag: formattedTag!)
                        } else {
                            let firstAdvertisementTag = advertisementViewModel.advertisement?.tags?.first(where: { $0.author == advertisementViewModel.advertisement?.author })
                            await advertisementViewModel.updateTag(advertisementTag: firstAdvertisementTag!, tag: formattedTag!)
                        }
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
                    for tag in stringTags {
                        let selectedProfileTag = tag
                        // format to tag
                        let formattedTag = tags.first(where: { $0.description == selectedProfileTag })
                        
                        // check if profile tags exists
                        if let pTags = profileTags, pTags.isEmpty {
                            await userProfileViewModel.createTag(userProfile: userProfileViewModel.userProfile!, tag: formattedTag!)
                        } else {
                            let firstUserProfileTag = userProfileViewModel.userProfile?.tags?.first(where: { $0.author == userProfileViewModel.userProfile?.author })
                            await userProfileViewModel.updateTag(userProfileTag: firstUserProfileTag!, tag: formattedTag!)
                        }
                    }
                }
            }
        }
        dismiss()
    }
    
}


#Preview {
    MultiPickerView(advertisementViewModel: AdvertisementViewModel(advertisements: AdvertisementViewModel.sampleData), isAdvertisement: true)
}

#Preview("UserProfile") {
    MultiPickerView(userProfileViewModel: UserProfileViewModel(userProfile: UserProfileViewModel.sampleData[0]), isAdvertisement: false)
}
