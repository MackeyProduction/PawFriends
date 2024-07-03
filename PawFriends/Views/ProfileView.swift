//
//  ProfileView.swift
//  PawFriends
//
//  Created by Til Anheier on 31.05.24.
//

import SwiftUI
import Amplify
import class Amplify.List

struct ProfileView: View {
    @ObservedObject private var userProfileViewModel: UserProfileViewModel
    @State private var authorName: String? = nil
    @State private var petType: PetType? = nil
    @State private var isShowingTagsSheet = false
    @State private var isShowingDescriptionSheet = false
    @State private var newPet: Pet? = nil
    @State private var tag: String? = "tag"
    @State private var tags: [Tag] = []
    @State private var tagCloud: [String] = []
    @State private var followers: [UserProfileFollower] = []
    @State private var isMyProfile: Bool
    
    init(userProfileViewModel: UserProfileViewModel, authorName: String? = nil, petType: PetType? = nil, isShowingTagsSheet: Bool = false, isShowingDescriptionSheet: Bool = false, newPet: Pet? = nil, isMyProfile: Bool) {
        self.userProfileViewModel = userProfileViewModel
        self.authorName = authorName
        self.petType = petType
        self.isShowingTagsSheet = isShowingTagsSheet
        self.isShowingDescriptionSheet = isShowingDescriptionSheet
        self.newPet = newPet
        self.isMyProfile = isMyProfile
    }
    
    @State private var navigateToSettings = false
    
    func dateToString(releaseDate: Temporal.Date) -> String {
        let relativeDateFormatter = DateFormatter()
        relativeDateFormatter.timeStyle = .none
        relativeDateFormatter.dateStyle = .medium
        relativeDateFormatter.locale = Locale(identifier: "de_DE")
        relativeDateFormatter.doesRelativeDateFormatting = true
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        //let date = Date(timeIntervalSinceNow: -131231)
        let timeString = timeFormatter.string(from: releaseDate.foundationDate)
        let relativeDateString = relativeDateFormatter.string(from: releaseDate.foundationDate)
        let RelativeDateTimeString = relativeDateString+", "+timeString
        
        return RelativeDateTimeString
    }
    
    var body: some View {
        NavigationSplitView {
            ScrollView {
                if let userProfile = userProfileViewModel.userProfile {
                    VStack(spacing: 5) {
                        
                        ZStack {
                            HStack {
                                Text("Mein Profil")
                                    .font(.title)
                                    .fontWeight(.medium)
                            }
                            
                            HStack {
                                Spacer()
                                Button(action: shareItem) {
                                    Label("", systemImage: "square.and.arrow.up")
                                }
                                .padding(.bottom, 5)
                                .font(.title2)
                                if isMyProfile {
                                    Button(action: {
                                        navigateToSettings = true
                                    }) {
                                        Label("", systemImage: "gearshape.fill")
                                    }
                                    .font(.title2)
                                    .navigationDestination(isPresented: $navigateToSettings) {
                                        SettingsView()
                                    }
                                }
                            }
                        }.foregroundStyle(Color(textColor!))
                        
                        Divider()
                            .overlay(Color(textColor!))
                        
                        HStack {
                            Image(systemName: "person.crop.square.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .padding(.trailing, 2)
                                .foregroundColor(Color(firstColor!))
                            
                            VStack(alignment: .leading) {
                                Text("\(authorName ?? "")")
                                //Text("Anna")
                                    .font(.largeTitle)
                                HStack {
                                    Image(systemName: "bookmark")
                                    Text("Aktiv seit: \(dateToString(releaseDate: userProfile.activeSince ?? Temporal.Date.now()))")
                                        .foregroundStyle(Color(textColor!))
                                        .padding(.leading, -5)
                                }
                            }
                            Spacer()
                        }.padding(.top)
                        
                        HStack {
                            Image(systemName: "person.3.fill")
                            Text("\(followers.count) Follower")
                            Spacer()
                        }
                        .padding([.top, .bottom], 5)
                        
                        HStack {
                            Image(systemName: "number.square")
                                .font(.headline)
                            
                            TagCloudView(tags: tagCloud)
                            
                            if isMyProfile {
                                Button(action: { isShowingTagsSheet.toggle() }) {
                                    Image(systemName: "square.and.pencil")
                                        .font(.title2)
                                }
                                .sheet(isPresented: $isShowingTagsSheet) {
                                    NavigationStack {
                                        Form {
                                            Picker("Tags", selection: $tag) {
                                                ForEach(tags, id: \.id) { tag in
                                                    Text(tag.description ?? "")
                                                        .tag(tag.description as String?)
                                                }
                                            }
                                        }
                                        .navigationTitle("Tags bearbeiten")
                                        .toolbar {
                                            ToolbarItem(placement: .confirmationAction) {
                                                Button("Done", action: createOrUpdateProfileTags)
                                            }
                                            
                                            ToolbarItem(placement: .cancellationAction) {
                                                Button("Cancel", action: { isShowingTagsSheet.toggle() })
                                            }
                                        }
                                        .onAppear {
                                            Task {
                                                self.tags = await userProfileViewModel.fetchTags()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .padding([.top, .bottom], 5)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Divider()
                    
                    VStack(spacing: 5) {
                        HStack {
                            Text("Beschreibung")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Spacer()
                            
                            if isMyProfile {
                                Button(action: { isShowingDescriptionSheet.toggle() }) {
                                    Image(systemName: "square.and.pencil")
                                        .font(.title2)
                                }
                                .sheet(isPresented: $isShowingDescriptionSheet) {
                                    NavigationStack {
                                        Form {
                                            TextField("Beschreibung", text: Binding(
                                                get: { userProfile.description ?? "" },
                                                set: { userProfileViewModel.userProfile?.description = $0 }
                                            ), axis: .vertical)
                                            .autocorrectionDisabled()
                                        }
                                        .navigationTitle("Beschreibung hinzufügen")
                                        .toolbar {
                                            ToolbarItem(placement: .confirmationAction) {
                                                Button("Done", action: updateProfile)
                                            }
                                            
                                            ToolbarItem(placement: .cancellationAction) {
                                                Button("Cancel", action: { isShowingDescriptionSheet.toggle() })
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                        HStack {
                            Text("\(userProfile.description ?? "")")
                            Spacer()
                        }
                        
                    }
                    
                    Divider()
                        .overlay(Color(textColor!))
                    
                    if let pets = userProfile.pets, userProfile.pets!.isLoaded {
                        if isMyProfile {
                            ProfilePetsList(vm: userProfileViewModel, pets: pets.elements, isMyProfile: true)
                        } else {
                            ProfilePetsList(vm: userProfileViewModel, pets: pets.elements, isMyProfile: false)
                        }
                    }
                    
                    Divider()
                        .overlay(Color(textColor!))
                    
                    if let advertisements = userProfile.advertisements, userProfile.advertisements!.isLoaded {
                        if isMyProfile {
                            ProfileAdvertisementList(vm: userProfileViewModel, advertisementViewModel: AdvertisementViewModel(advertisements: AdvertisementViewModel.sampleData),  advertisements: advertisements.elements, isMyProfile: true)
                        } else {
                            ProfileAdvertisementList(vm: userProfileViewModel, advertisementViewModel: AdvertisementViewModel(advertisements: AdvertisementViewModel.sampleData),  advertisements: advertisements.elements, isMyProfile: false)
                        }
                    }
                    
                    Divider()
                                        
                    Spacer()
                } else {
                    ContentUnavailableView {
                        Label("Profil nicht gefunden", systemImage: "person")
                    }
                }
            }
            .padding(.leading)
            .padding(.trailing)
            .background(Color(mainColor!))
        } detail: {
            Text("Select an item")
                .navigationTitle("Profil")
        }
        .onAppear {
            Task {
                do {
                    try await userProfileViewModel.userProfile?.pets?.fetch()
                    try await userProfileViewModel.userProfile?.advertisements?.fetch()
                    try await userProfileViewModel.userProfile?.tags?.fetch()
                    try await userProfileViewModel.userProfile?.followers?.fetch()
                    try await loadTagCloud()
                    self.authorName = await userProfileViewModel.getAuthorName()
                    self.followers = userProfileViewModel.userProfile?.followers?.elements ?? []
                }
            }
            
        }
    }
    
    private func loadTagCloud() async throws {
        do {
            let tagItems = userProfileViewModel.userProfile?.tags?.elements
            for item in tagItems! {
                let tag = try await item.tag
                self.tagCloud.append(tag?.description ?? "")
            }
        } catch {
            print("Could not fetch tags for tag cloud.")
        }
    }
    
    private func shareItem(){
        
    }
    
    private func updateProfile() {
        Task {
            await userProfileViewModel.updateProfile(userProfile: userProfileViewModel.userProfile!)
            
            isShowingDescriptionSheet.toggle()
        }
    }
    
    private func createOrUpdateProfileTags() {
        do {
            Task {
                // load profile tags
                let profileTags = userProfileViewModel.userProfile?.tags?.elements
                
                if let selectedProfileTag = tag {
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
                
                isShowingTagsSheet.toggle()
            }
        }
    }
    
}

#Preview {
    ProfileView(userProfileViewModel: UserProfileViewModel(userProfile: UserProfileViewModel.sampleData[0]), isMyProfile: true)
}

#Preview ("another profile") {
    ProfileView(userProfileViewModel: UserProfileViewModel(userProfile: UserProfileViewModel.sampleData[0]), isMyProfile: false)
}

