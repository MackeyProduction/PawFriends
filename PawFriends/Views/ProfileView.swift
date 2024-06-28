//
//  ProfileView.swift
//  PawFriends
//
//  Created by Til Anheier on 31.05.24.
//

import SwiftUI
import Amplify

struct ProfileView: View {
    @ObservedObject private var userProfileViewModel: UserProfileViewModel
    @State private var authorName: String? = nil
    @State private var petType: PetType? = nil
    @State private var isShowingDescriptionSheet = false
    @State private var isShowingPetsSheet = false
    @State private var isShowingAdvertisementSheet = false
    @State private var newPet: Pet? = nil
    
    init(userProfileViewModel: UserProfileViewModel, authorName: String? = nil, petType: PetType? = nil, isShowingDescriptionSheet: Bool = false, isShowingPetsSheet: Bool = false, isShowingAdvertisementSheet: Bool = false, newPet: Pet? = nil) {
        self.userProfileViewModel = userProfileViewModel
        self.authorName = authorName
        self.petType = petType
        self.isShowingDescriptionSheet = isShowingDescriptionSheet
        self.isShowingPetsSheet = isShowingPetsSheet
        self.isShowingAdvertisementSheet = isShowingAdvertisementSheet
        self.newPet = newPet
    }
    
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
                                Text("\(authorName ?? "")")
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
                                            Button("Done", action: { isShowingDescriptionSheet.toggle() })
                                        }
                                        
                                        ToolbarItem(placement: .cancellationAction) {
                                            Button("Cancel", action: { isShowingDescriptionSheet.toggle() })
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
                        PetsList(vm: userProfileViewModel, pets: pets.elements)
                    }
                    
                    Divider()
                        .overlay(Color(textColor!))
                    
                    VStack(spacing: 5) {
                        HStack {
                            Text("Anzeigen")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Spacer()
                            Button(action: { isShowingAdvertisementSheet.toggle() }) {
                                Image(systemName: "plus.square")
                                    .font(.title2)
                            }
                        }.padding(.bottom, 5)
                        
                        if let advertisements = userProfile.advertisements, userProfile.advertisements!.isLoaded {
                            ForEach(advertisements.elements, id: \.id) { advertisement in
                                
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
                                        Button(action: { isShowingAdvertisementSheet.toggle() }) {
                                            Image(systemName: "square.and.pencil")
                                                .font(.title3)
                                                .foregroundStyle(Color(greenColorReverse!))
                                        }
                                    }.padding(.top, 8)
                                    Divider()
                                }
                            }
                        }
                    }.padding(.top, 5).padding(.bottom, 5)
                        .sheet(isPresented: $isShowingAdvertisementSheet) {
                            NavigationStack {
                                Form {
                                    TextField("Tiername", text: Binding(
                                        get: { userProfile.description ?? "" },
                                        set: { userProfileViewModel.userProfile?.description = $0 }
                                    ), axis: .vertical)
                                    .autocorrectionDisabled()
                                }
                                .navigationTitle("Anzeige hinzufügen")
                                .toolbar {
                                    ToolbarItem(placement: .confirmationAction) {
                                        Button("Done", action: { isShowingAdvertisementSheet.toggle() })
                                    }
                                    
                                    ToolbarItem(placement: .cancellationAction) {
                                        Button("Cancel", action: { isShowingAdvertisementSheet.toggle() })
                                    }
                                }
                            }
                        }
                    
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
                    self.authorName = await userProfileViewModel.getAuthorName()
                }
            }
            
        }
    }
    
    
    private func shareItem(){
        
    }
    
    private func getPetType(pet: Pet) -> String? {
        Task {
            return try await pet.petType?.description
        }
        return ""
    }
    
}

#Preview {
    ProfileView(userProfileViewModel: UserProfileViewModel(userProfile: UserProfileViewModel.sampleData[0]))
}
