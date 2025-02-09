//
//  ProfilePetsRow.swift
//  PawFriends
//
//  Created by Til Anheier on 27.06.24.
//

import SwiftUI

struct ProfilePetsRow: View {
    @ObservedObject var vm: UserProfileViewModel
    @Binding var pet: Pet
    @State private var petType: PetType? = nil
    @State private var isShowingPetsSheet = false
    @State private var navigateToPetDetail = false
    @State var isMyProfile: Bool
    
    var body: some View {
        ZStack {
            HStack {
                Button(action: {
                    navigateToPetDetail = true
                }) {
                    Image(systemName: "pawprint.circle.fill")
                        .font(.title)
                        .foregroundStyle(Color(greenColorReverse!))
                    Text(pet.name ?? "Tier nicht gefunden")
                        .fontWeight(.medium)
                }
                .navigationDestination(isPresented: $navigateToPetDetail) {
                    PetDetail(vm: vm, pet: $pet)}
                Spacer()
            }
            HStack {
                Divider()
                    .overlay(Color(textColor!))
            }
            HStack {
                Text(petType?.description ?? "")
                    .padding(.leading, 60)
            }
            HStack {
                Spacer()
                if isMyProfile {
                    Button(action: { isShowingPetsSheet.toggle() }) {
                        Image(systemName: "square.and.pencil")
                            .font(.title3)
                            .foregroundStyle(Color(greenColorReverse!))
                    }
                }
            }
        }
        .padding(.top, 2)
        .sheet(isPresented: $isShowingPetsSheet) {
            NavigationStack {
                ProfilePetsSheet(vm: vm, pet: $pet)
            }
        }
        .onAppear {
            Task {
                self.petType = try await pet.petType
            }
        }
    }
}

#Preview {
    ProfilePetsRow(vm: UserProfileViewModel(userProfile: UserProfileViewModel.sampleData[0]), pet: Binding.constant(UserProfileViewModel.sampleData[0].pets?.first ?? Pet()), isMyProfile: true)
}

#Preview("another profile") {
    ProfilePetsRow(vm: UserProfileViewModel(userProfile: UserProfileViewModel.sampleData[0]), pet: Binding.constant(UserProfileViewModel.sampleData[0].pets?.first ?? Pet()), isMyProfile: false)
}
