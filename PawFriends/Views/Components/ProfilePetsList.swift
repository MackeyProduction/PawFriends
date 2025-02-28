//
//  ProfilePetsList.swift
//  PawFriends
//
//  Created by Til Anheier on 27.06.24.
//

import SwiftUI

struct ProfilePetsList: View {
    @ObservedObject var vm: UserProfileViewModel
    @Binding var pets: [Pet]
    @State private var newPet: Pet = Pet()
    @State private var petType: PetType? = nil
    @State private var isShowingPetsSheet = false
    @State var isMyProfile: Bool
    
    init(vm: UserProfileViewModel, pets: Binding<[Pet]>, petType: PetType? = nil, isShowingPetsSheet: Bool = false, isMyProfile: Bool) {
        self.vm = vm
        self._pets = pets
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
            }.padding(.bottom, 5)
            
            if !pets.isEmpty {
                ForEach($pets, id: \.id) { pet in
                    if isMyProfile {
                        ProfilePetsRow(vm: vm, pet: pet, isMyProfile: true)
                    } else {
                        ProfilePetsRow(vm: vm, pet: pet, isMyProfile: false)
                    }
                }
            } else {
                ContentUnavailableView {
                    Label("Keine Haustiere vorhanden", systemImage: "pawprint")
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
    ProfilePetsList(vm: UserProfileViewModel(userProfile: UserProfileViewModel.sampleData[0]), pets: Binding.constant([]), isMyProfile: true)
}

#Preview ("another profile") {
    ProfilePetsList(vm: UserProfileViewModel(userProfile: UserProfileViewModel.sampleData[0]), pets: Binding.constant([]), isMyProfile: false)
}
