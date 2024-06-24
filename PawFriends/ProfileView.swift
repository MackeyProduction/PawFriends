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

    init(advertisementArray: [Advertisement]) {
        
        self.advertisementArray = advertisementArray
    }
//    func getPetName() async {
//        do {
//            let pet = Pet()
//            
//            let userProfile = UserProfile()
//            
//            if let ads = userProfile.advertisements {
//                for ad in ads.elements {
//                    let a = try await ad.advertisement
//                }
//            }
//            
//            
//            let petBreed = try await pet.petBreed?.description
//            
//            if let breeds = try await pet._petBreed.get() {
//                
//            }
//            
//        } catch {
//            
//        }
//    }
    
    func getAdvertisements() async -> [Advertisement] {
        var advertisementsArray: [Advertisement] = []
        do {
            if let ads = userProfileViewModel.userProfile?.advertisements {
                for ad in ads.elements {
                    let a = try await ad.advertisement
                    advertisementsArray.append(a!)
                }
            }
        } catch {
            
        }
        return advertisementsArray
    }
    
    private lazy var breeds: [PetBreed] = {
        let pet = Pet()
        
        Task {
            if let breeds = try await pet._petBreed.get() {
                
            }
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
                                    //Text("Aktiv seit: 12.03.23")
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
                        
                        if let pets = userProfile.pets {
                            
                            //Text("\(pets.elements[0])")
                            let pets: [String] = ["Momo","Momo Klon"]
                            ForEach(pets, id: \.self) { pet in
                                //ForEach(pets.elements, id: \.id) { pet in
                                
                                
                                ZStack {
                                    HStack {
                                        Image(systemName: "pawprint.circle.fill")
                                            .font(.title)
                                            .foregroundStyle(Color(greenColorReverse!))
                                        Text(pet)
                                        //Text(pet._pet.get()?.name ?? "")
                                            .fontWeight(.medium)
                                        Spacer()
                                    }
                                    HStack {
                                        Divider()
                                            .overlay(Color(textColor!))
                                    }
                                    HStack {
                                        Text("Katze")
                                            .padding(.leading, 60)
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
                        
                        
                        
                        if let advertisements = userProfile.advertisements {
                            //                            ForEach(advertisements.elements, id: \.id) { item in
                            //                                Text("\(item._advertisement)")
                            //                            }
                            let anzeigen: [String] = ["Katzen-Sitter für Kater gesucht","Noch ein Anzeigen Titel"]
                            
                            
                            //ForEach(anzeigen, id: \.self) { advertisement in
                            //ForEach(advertisements.elements, id: \.id) { advertisement in
                            ForEach(advertisementArray, id: \.id) { advertisement in
                                
                                VStack {
                                    HStack {
                                        Image(systemName: "photo.fill")
                                            .font(.system(size: 70))
                                            .foregroundStyle(Color(greenColorReverse!))
                                            .padding(-8)
                                        VStack {
                                            HStack {
                                                //Text(advertisement.modelName)
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
                    advertisementArray = await getAdvertisements()
                }
                
            }
        }
    
    
    private func shareItem(){
        
    }
    
}

#Preview {
    ProfileView(advertisementArray: [])
}
