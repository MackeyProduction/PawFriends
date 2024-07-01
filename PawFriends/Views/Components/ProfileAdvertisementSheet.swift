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
            Section {
                //Text("Titel")
                TextField("Titel", text: Binding(
                    get: { advertisement.title ?? "" },
                    set: { advertisement.title = $0 }
                ), axis: .vertical)
                    .autocorrectionDisabled()
            }
            .listRowBackground(Color(thirdColor!))
            
//            Section { //Multi select, Kategorien sortiert
//                Picker("Tags", selection: $tags) {
//                    ForEach(tagOptions, id: \.self) {
//                        Text($0)
//                    }
//                }//.pickerStyle()
//            }
//            .listRowBackground(Color(thirdColor!))
            
            Section {
                Text("Beschreibung")
                TextField("", text: Binding(
                    get: { advertisement.description ?? "" },
                    set: { advertisement.description = $0 }
                ), axis: .vertical)
                    .autocorrectionDisabled()
                    .lineLimit(9...9)
            }
            .listRowBackground(Color(thirdColor!))
                                
//            Section(footer:
//                        HStack {
//                Spacer()
//                Button(action: createOrUpdate) {
//                    Text("Veröffentlichen")
//                        .font(.title2)
//                        .foregroundStyle(Color(mainTextColor!))
//                }
//                .padding(10)
//                .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color(greenColor!)))
//                Spacer()
//            }
//            ) {
//                EmptyView()
//            }
        }.scrollContentBackground(.hidden)
            .navigationTitle(isNew ? "Anzeige hinzufügen" : "Anzeige bearbeiten")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Fertig", action: createOrUpdate)
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen", action: { dismiss() })
                }
            }
        
//        Form {
//            TextField("Anzeigentitel", text: Binding(
//                get: { advertisement.title ?? "" },
//                set: { advertisement.title = $0 }
//            ), axis: .vertical)
//            .autocorrectionDisabled()
//            
//            TextField("Beschreibung", text: Binding(
//                get: { advertisement.description ?? "" },
//                set: { advertisement.description = $0 }
//            ), axis: .vertical)
//            .autocorrectionDisabled()
//        }
//        .navigationTitle(isNew ? "Anzeige hinzufügen" : "Anzeige bearbeiten")
//        .toolbar {
//            ToolbarItem(placement: .confirmationAction) {
//                Button("Done", action: createOrUpdate)
//            }
//            
//            ToolbarItem(placement: .cancellationAction) {
//                Button("Cancel", action: { dismiss() })
//            }
//        }
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
