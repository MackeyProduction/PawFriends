//
//  ProfileAdvertisementSheet.swift
//  PawFriends
//
//  Created by Til Anheier on 28.06.24.
//

import SwiftUI

struct ProfileAdvertisementSheet: View {
    @ObservedObject var vm: UserProfileViewModel
    @Binding var advertisement: Advertisement
    @State var isNew: Bool = false
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
            TextField("Anzeigentitel", text: Binding(
                get: { advertisement.title ?? "" },
                set: { advertisement.title = $0 }
            ), axis: .vertical)
            .autocorrectionDisabled()
            
            TextField("Beschreibung", text: Binding(
                get: { advertisement.description ?? "" },
                set: { advertisement.description = $0 }
            ), axis: .vertical)
            .autocorrectionDisabled()
        }
        .navigationTitle(isNew ? "Anzeige hinzufügen" : "Anzeige bearbeiten")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done", action: createOrUpdate)
            }
            
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", action: { dismiss() })
            }
        }
    }
    
    private func createOrUpdate() {
        Task {
            do {
                // check if we have a new or an existing advertisement
                if isNew {
                    await vm.createAdvertisement(userProfile: vm.userProfile!, advertisement: advertisement)
                } else {
                    await vm.updateAdvertisement(userProfile: vm.userProfile!, advertisement: advertisement)
                }
                
                // reload advertisements
                try await vm.userProfile?.advertisements?.fetch()
                
                dismiss()
            }
        }
    }
}

#Preview {
    NavigationStack {
        @State var advertisement = UserProfileViewModel.sampleData[0].advertisements?.first ?? Advertisement()
        ProfileAdvertisementSheet(vm: UserProfileViewModel(userProfile: UserProfileViewModel.sampleData[0]), advertisement: $advertisement)
    }
}
