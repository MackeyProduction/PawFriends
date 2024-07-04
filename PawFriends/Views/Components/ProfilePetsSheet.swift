//
//  ProfilePetsSheet.swift
//  PawFriends
//
//  Created by Til Anheier on 27.06.24.
//

import SwiftUI
import Amplify
import class Amplify.List
import PhotosUI

struct ProfilePetsSheet: View {
    @ObservedObject var vm: UserProfileViewModel
    @Binding var pet: Pet
    @State var isNew: Bool
    @State private var petTypes: [PetType] = []
    @State private var petType: String? = nil
    
    @StateObject private var viewModel = PhotoPickerViewModel()
    @State var imageSelections: [PhotosPickerItem] = []
    
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
    
    func stringToUiimages(strings: [String?]?) -> [UIImage]{
        var uiimages: [UIImage] = []
        for string in strings! {
            let image: Image = Image(string!)
            uiimages.append(image.asUIImage())
        }
        return uiimages
    }
    
    var body: some View {
        VStack(spacing: 10) {
            if viewModel.selectedImages.isEmpty {
                ZStack {
                    Rectangle()
                        .fill(Color(secondColor!))
                        .frame(maxWidth: .infinity, maxHeight: 270)
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: 250, alignment: .center)
                        .clipped()
                        .foregroundStyle(Color(textColor!))
                        .opacity(0.2)
                        .overlay(alignment: .bottomTrailing) {
                            PhotosPicker(selection: $viewModel.imageSelections,
                                         matching: .images,
                                         photoLibrary: .shared()) {
                                PickPhotoButton()
                                    .padding(.bottom, 5)
                                    .padding(.trailing, 5)
                            }
                                         .buttonStyle(.borderless)
                        }
                }
                .frame(height: 270)
            } else {
                //SwipeView(images: viewModel.selectedImages)
                Image(uiImage: viewModel.selectedImages[0])
                    .resizable()
                    .scaledToFill()
                    .frame(height: 270, alignment: .top)
                    .clipped()
                    .overlay(alignment: .bottomTrailing) {
                        PhotosPicker(selection: $viewModel.imageSelections,
                                     matching: .images,
                                     photoLibrary: .shared()) {
                            PickPhotoButton()
                                .padding(.bottom, 5)
                                .padding(.trailing, 5)
                        }
                                     .buttonStyle(.borderless)
                    }
            }
            
            Form {
                Section {
                    TextField("Name", text: Binding(
                        get: { pet.name ?? "" },
                        set: { pet.name = $0 }
                    ), axis: .vertical)
                        .autocorrectionDisabled()
                }
                .listRowBackground(Color(thirdColor!))
                
                Section {
                    Text("Beschreibung")
                    TextField("", text: Binding(
                        get: { pet.description ?? "" },
                        set: { pet.description = $0 }
                    ), axis: .vertical)
                        .autocorrectionDisabled()
                        .lineLimit(9...9)
                }
                .listRowBackground(Color(thirdColor!))
                
                Section {
                    Text("Alter")
                    TextField("", value: Binding(
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
                }.listRowBackground(Color(thirdColor!))

                Section {
                    Picker("Tiertypen", selection: $petType) {
                        Text("None")
                            .tag(nil as String?)
                        
                        ForEach(petTypes, id: \.id) { petType in
                            Text(petType.description ?? "")
                                .tag(petType.description as String?)
                        }
                    }
                }.listRowBackground(Color(thirdColor!))
                                    
                Section(footer:
                            HStack {
                    Spacer()
                    Button(action: createOrUpdate) {
                        Text("Veröffentlichen")
                            .font(.title2)
                            .foregroundStyle(Color(mainTextColor!))
                    }
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color(greenColor!)))
                    Spacer()
                }
                ) {
                    EmptyView()
                }
            }.scrollContentBackground(.hidden)
                //.navigationTitle(isNew ? "Haustier hinzufügen" : "Huastier bearbeiten")
                .toolbar {
//                        ToolbarItem(placement: .confirmationAction) {
//                            Button("Done", action: createOrUpdate)
//                        }
                    
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Abbrechen", action: { dismiss() })
                    }
                }
                .onAppear {
                    Task {
                        self.petTypes = await vm.fetchPetTypes()
                    }
                }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
        .background(Color(mainColor!))
        .edgesIgnoringSafeArea(.top)
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
                await vm.fetchPets(userProfile: vm.userProfile!)
                
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
