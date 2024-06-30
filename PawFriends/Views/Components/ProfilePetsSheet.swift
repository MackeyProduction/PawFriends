//
//  ProfilePetsSheet.swift
//  PawFriends
//
//  Created by Til Anheier on 27.06.24.
//

import SwiftUI
import Amplify
import class Amplify.List

struct ProfilePetsSheet: View {
    @ObservedObject var vm: UserProfileViewModel
    @Binding var pet: Pet
    @State var isNew: Bool
    @State private var petTypes: [PetType] = []
    @State private var petType: String? = nil
    
    @Environment(\.dismiss) private var dismiss
    
    init(vm: UserProfileViewModel, pet: Binding<Pet>, isNew: Bool = false) {
        self.vm = vm
        self._pet = pet
        self.isNew = isNew
    }
    
    // Auf Basis von: https://letscode.thomassillmann.de/textfeld-auf-basis-von-zahlenwerten-in-swiftui/
    private var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter
    }
    
    var body: some View {
        Form {
            TextField("Tiername", text: Binding(
                get: { pet.name ?? "" },
                set: { pet.name = $0 }
            ), axis: .vertical)
            .autocorrectionDisabled()
            
            TextField("Beschreibung", text: Binding(
                get: { pet.description ?? "" },
                set: { pet.description = $0 }
            ), axis: .vertical)
            .autocorrectionDisabled()
            
            TextField("Alter", value: Binding(
                get: {
                    if let age = pet.age {
                        return age
                    }
                    return 1 // Default value if pet.age is nil
                },
                set: { newValue in
                    pet.age = Int(newValue)
                }
            ), formatter: numberFormatter)
                .keyboardType(.numberPad)
            
            Picker("Tiertypen", selection: $petType) {
                Text("None")
                    .tag(nil as String?)
                
                ForEach(petTypes, id: \.id) { petType in
                    Text(petType.description ?? "")
                        .tag(petType.description as String?)
                }
            }
        }
        .navigationTitle(isNew ? "Haustier hinzufügen" : "Haustier bearbeiten")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done", action: createOrUpdate)
            }
            
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", action: { dismiss() })
            }
        }
        .onAppear {
            Task {
                self.petTypes = await vm.fetchPetTypes()
            }
        }
    }
    
    private func createOrUpdate() {
        Task {
            do {
                // check if a pet type is selected and use it as relation
                if let selectedPetType = petType {
                    let formattedPetType = petTypes.first(where: { $0.description == selectedPetType })
                    pet.setPetType(formattedPetType)
                }
                
                // check if we have a new or an existing pet
                if isNew {
                    await vm.createPet(userProfile: vm.userProfile!, pet: pet)
                } else {
                    await vm.updatePet(userProfile: vm.userProfile!, pet: pet)
                }
                
                // reload pets
                try await vm.userProfile?.pets?.fetch()
                
                dismiss()
            }
        }
    }
}

#Preview {
    NavigationStack {
        @State var pet = UserProfileViewModel.sampleData[0].pets?.first ?? Pet()
        ProfilePetsSheet(vm: UserProfileViewModel(userProfile: UserProfileViewModel.sampleData[0]), pet: $pet)
    }
}
