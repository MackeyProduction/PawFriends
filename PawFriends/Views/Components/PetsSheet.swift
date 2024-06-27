//
//  PetsSheet.swift
//  PawFriends
//
//  Created by Til Anheier on 27.06.24.
//

import SwiftUI

struct PetsSheet: View {
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
    
    var body: some View {
        Form {
            TextField("Tiername", text: Binding(
                get: { pet.name ?? "" },
                set: { pet.name = $0 }
            ), axis: .vertical)
            .autocorrectionDisabled()
            
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
                Button("Done", action: { dismiss() })
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
}

#Preview {
    NavigationStack {
        @State var pet = UserProfileViewModel.sampleData[0].pets?.first ?? Pet()
        PetsSheet(vm: UserProfileViewModel(userProfile: UserProfileViewModel.sampleData[0]), pet: $pet)
    }
}
