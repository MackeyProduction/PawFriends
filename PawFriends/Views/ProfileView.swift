//
//  ProfileView.swift
//  PawFriends
//
//  Created by Til Anheier on 31.05.24.
//

import SwiftUI
import Amplify

struct ProfileView: View {
    @StateObject private var userProfileViewModel: UserProfileViewModel = UserProfileViewModel()
    @State private var advertisementArray: [Advertisement]
    @State private var petArray: [Pet]
    @State private var tagArray: [String]
    @State private var petType: String

    init(advertisementArray: [Advertisement], petArray: [Pet], tagArray: [String], petType: String) {
        self.advertisementArray = advertisementArray
        self.petArray = petArray
        self.tagArray = tagArray
        self.petType = petType
    }
 
    
    func getAdvertisements() -> [Advertisement] {
        var advertisementsArray: [Advertisement] = []
        if let ads = userProfileViewModel.userProfile?.advertisements {
            for ad in ads.elements {
                advertisementsArray.append(ad)
            }
        }
        return advertisementsArray
    }
    
    func getPets() -> [Pet] {
        var petsArray: [Pet] = []
        if let pets = userProfileViewModel.userProfile?.pets {
            for pet in pets.elements {
                petsArray.append(pet)
            }
        }
        return petsArray
    }
    
    func getTagStrings() -> [String] {
        var tagsArray: [String] = []
        if let tags = userProfileViewModel.userProfile?.tags {
            for tag in tags.elements {
                //tagsArray.append(tag)
            }
        }
        return tagsArray
    }
    
    func getPetType(pet: Pet) async -> String {
        var petType: String = ""
        do {
            petType = try await pet.petType?.description! ?? ""
        }
        catch {}
        return petType

    }
    
    
    private lazy var breeds: [PetBreed] = {
        let pet = Pet()
        
        Task {
            if let breeds = try await pet._petBreed.get() {}
        }
        return []
    }()
    
    
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
                                Button(action: {}) {
                                    Label("", systemImage: "gearshape.fill")
                                }
                                .font(.title2)
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
                                Text("\(userProfile.author ?? "")")
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
                            Text("2 Follower")
                            Spacer()
                        }
                        .padding([.top, .bottom], 5)
                        
                        HStack {
                            Image(systemName: "number.square")
                                .font(.headline)
                            //Text("")
                            TagCloudView(tags: ["Nicht-Raucher","sportlich","Katzen-Kenner"])
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
                            Image(systemName: "square.and.pencil")
                                .font(.title2)
                        }
                        
                        HStack {
                            Text("\(userProfile.description ?? "")")
                            Spacer()
                        }
                        
                    }
                    
                    Divider()
                        .overlay(Color(textColor!))
                    
                    VStack(spacing: 5) {
                        HStack {
                            Text("Tiere")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Spacer()
                            Image(systemName: "plus.square")
                                .font(.title2)
                        }.padding(.bottom, 5)
                        
                        if !petArray.isEmpty {
                            ForEach(petArray, id: \.id) { pet in
                                ZStack {
                                    HStack {
                                        Image(systemName: "pawprint.circle.fill")
                                            .font(.title)
                                            .foregroundStyle(Color(greenColorReverse!))
                                        Text(pet.name ?? "")
                                            .fontWeight(.medium)
                                        Spacer()
                                    }
                                    HStack {
                                        Divider()
                                            .overlay(Color(textColor!))
                                    }
                                    //petType nicht dynamisch
                                    HStack {
                                        Text(petType)
                                            .padding(.leading, 60)
                                    }.onAppear(){
                                        Task{
                                            petType = await getPetType(pet: pet)
                                        }
                                    }
                                    HStack {
                                        Spacer()
                                        Image(systemName: "square.and.pencil")
                                            .font(.title3)
                                            .foregroundStyle(Color(greenColorReverse!))
                                    }
                                }.padding(.top, 2)
                            }
                        }
                    }.padding(.top, 5).padding(.bottom, 5)
                    
                    Divider()
                        .overlay(Color(textColor!))
                    
                    VStack(spacing: 5) {
                        HStack {
                            Text("Anzeigen")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Spacer()
                            Image(systemName: "plus.square")
                                .font(.title2)
                        }.padding(.bottom, 5)
                        
                        
                        
                        if !advertisementArray.isEmpty {
                            ForEach(advertisementArray, id: \.id) { advertisement in
                                
                                VStack {
                                    HStack {
                                        Image(systemName: "photo.fill")
                                            .font(.system(size: 70))
                                            .foregroundStyle(Color(greenColorReverse!))
                                            .padding(-8)
                                        VStack {
                                            HStack {
                                                Text(advertisement.title ?? "")
                                                    .fontWeight(.medium)
                                                Spacer()
                                                
                                            }
                                            HStack {
                                                Image(systemName: "calendar")
                                                    .font(.callout)
                                                    .frame(width: 10)
                                                    .padding(.leading, 5)
                                                Text("18.04.24")
                                                    .padding(.trailing, 50)
                                                Spacer()
                                            }.foregroundStyle(Color(textColor!))
                                        }
                                        Spacer()
                                        Image(systemName: "square.and.pencil")
                                            .font(.title3)
                                            .foregroundStyle(Color(greenColorReverse!))
                                    }.padding(.top, 8)
                                    Divider()
                                }
                            }
                        }
                    }.padding(.top, 5).padding(.bottom, 5)
                    
                    Spacer()
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
                    //advertisementArray = await getAdvertisements()
                    advertisementArray = getAdvertisements()
                    petArray = getPets()
                    tagArray = getTagStrings()
                }
                
            }
        }
    
    
    private func shareItem(){
        
    }
    
}

#Preview {
    ProfileView(advertisementArray: [], petArray: [], tagArray: [], petType: "")
}
