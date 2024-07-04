//
//  ProfilePetsList.swift
//  PawFriends
//
//  Created by Til Anheier on 27.06.24.
//

import SwiftUI

struct ProfilePetsList: View {
    @ObservedObject var vm: UserProfileViewModel
    @State var pets: [Pet]
    @State private var newPet: Pet = Pet()
    @State private var petType: PetType? = nil
    @State private var isShowingPetsSheet = false
    @State var isMyProfile: Bool
    //@State private var navigateToPetDetail = false
    
    init(vm: UserProfileViewModel, pets: [Pet] = [], petType: PetType? = nil, isShowingPetsSheet: Bool = false, isMyProfile: Bool) {
        self.vm = vm
        self.pets = pets
        self.petType = petType
        self.isShowingPetsSheet = isShowingPetsSheet
        self.isMyProfile = isMyProfile
    }
    
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Text("Tiere")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
                if isMyProfile {
                    Button(action: { isShowingPetsSheet.toggle() }) {
                        Image(systemName: "plus.square")
                            .font(.title2)
                    }
                }
//                Button(action: {
//                    navigateToPetDetail = true
//                }) {
//                    Label("", systemImage: "plus.square")
//                }
//                .padding(.trailing, -8)
//                .font(.title2)
//                .navigationDestination(isPresented: $navigateToPetDetail) {
//                    PetDetail(vm: vm, pet: $newPet, isNew: true).navigationBarBackButtonHidden(true)
//                               }
            }.padding(.bottom, 5)
            
            if !pets.isEmpty {
                ForEach(pets, id: \.id) { pet in
                    if isMyProfile {
                        ProfilePetsRow(vm: vm, pet: pet, isMyProfile: true)
                    } else {
                        ProfilePetsRow(vm: vm, pet: pet, isMyProfile: false)
                    }
                }
            }
        }
        .padding(.top, 5).padding(.bottom, 5)
        .sheet(isPresented: $isShowingPetsSheet) {
            NavigationStack {
                ProfilePetsSheet(vm: vm, pet: $newPet, isNew: true)
            }
        }
    }
}

#Preview {
    ProfilePetsList(vm: UserProfileViewModel(userProfile: UserProfileViewModel.sampleData[0]), isMyProfile: true)
}

#Preview ("another profile") {
    ProfilePetsList(vm: UserProfileViewModel(userProfile: UserProfileViewModel.sampleData[0]), isMyProfile: false)
}
