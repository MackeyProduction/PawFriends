//
//  PetsList.swift
//  PawFriends
//
//  Created by Til Anheier on 27.06.24.
//

import SwiftUI

struct PetsList: View {
    @ObservedObject var vm: UserProfileViewModel
    @State var pets: [Pet]
    @State private var petType: PetType? = nil
    @State private var isShowingPetsSheet = false
    
    init(vm: UserProfileViewModel, pets: [Pet] = [], petType: PetType? = nil, isShowingPetsSheet: Bool = false) {
        self.vm = vm
        self.pets = pets
        self.petType = petType
        self.isShowingPetsSheet = isShowingPetsSheet
    }
    
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Text("Tiere")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
                Button(action: { isShowingPetsSheet.toggle() }) {
                    Image(systemName: "plus.square")
                        .font(.title2)
                }
            }.padding(.bottom, 5)
            
            if !pets.isEmpty {
                ForEach(pets, id: \.id) { pet in
                    PetsRow(vm: vm, pet: pet)
                }
            }
        }
        .padding(.top, 5).padding(.bottom, 5)
        .sheet(isPresented: $isShowingPetsSheet) {
            NavigationStack {
                @State var pet = Pet()
                PetsSheet(vm: vm, pet: $pet, isNew: true)
            }
        }
    }
}

#Preview {
    PetsList(vm: UserProfileViewModel(userProfile: UserProfileViewModel.sampleData[0]))
}
