//
//  PetDetail.swift
//  PawFriends
//
//  Created by Hanna Steffen on 01.07.24.
//

import SwiftUI
import Amplify
import class Amplify.List
import PhotosUI

struct PetDetail: View {
    @ObservedObject var vm: UserProfileViewModel
    @Binding var pet: Pet
    @State var isNew: Bool
    @State private var petTypes: [PetType] = []
    @State private var petType: String? = nil
    @State private var petTypeType: PetType? = nil
    @State private var petUserProfile: UserProfile? = nil
    
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
        //GeometryReader { g in
        ScrollView {
            VStack(spacing: 10) {
                if pet.petImage == true {
                    //                            let images: [UIImage] = stringToUiimages(strings: pet.petImage)
                    let images: [UIImage] = [Image("TestImage2").asUIImage()]
                    Image(uiImage: images[0])
                        .resizable()
                        .scaledToFill()
                        .frame(height: 270, alignment: .top)
                        .clipped()
                    
                } else {
                    //                            Image(systemName: "photo")
                    //                                .resizable()
                    //                                .scaledToFit()
                    //                                .frame(maxWidth: .infinity, maxHeight: 250, alignment: .center)
                    //                                .clipped()
                    //                                .opacity(0.2)
                    Image("TestImage2")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 270, alignment: .top)
                        .clipped()
                }
                
                VStack(spacing: 5) {
                    Text(pet.name ?? "Kein Name")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        Image(systemName: "calendar")
                            .font(.headline)
                            .frame(width: 10)
                            .padding(.trailing, 5)
                        Text("Alter: "+"\(pet.age ?? 0)")
                            .font(.headline)
                        Spacer()
                        Image(systemName: "pawprint")
                            .font(.headline)
                            .frame(width: 10)
                            .padding(.trailing, 5)
                        Text(petTypeType?.description ?? "")
                            .font(.headline)
                    }
                    .foregroundStyle(Color(textColor!))
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                    
                    Divider()
                        .background(Color(textColor!))
                    
                    Text(pet.description ?? "Keine Beschreibung")
                        .font(.callout)
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                }
                .padding(.leading)
                .padding(.trailing)
                
                Divider()
                    .background(Color(textColor!))
                
                if let up = petUserProfile {
                    DetailProfileInfos(vm: vm, title: "Anbieter", authorId: up.author ?? "")
                        .padding(.top, 10)
                        .padding(.bottom, 20)
                        .padding(.leading)
                        .padding(.trailing)
                }
                
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
            //.edgesIgnoringSafeArea(.top)
        }
        .background(Color(mainColor!))
        .edgesIgnoringSafeArea(.top)
        .onAppear {
            Task {
                self.petTypeType = try await pet.petType
                self.petUserProfile = try await pet.userProfile
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
        PetDetail(vm: UserProfileViewModel(userProfile: UserProfileViewModel.sampleData[0]), pet: $pet)
    }
}

