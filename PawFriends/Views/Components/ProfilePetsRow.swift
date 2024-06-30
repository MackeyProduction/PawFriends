//
//  ProfilePetsRow.swift
//  PawFriends
//
//  Created by Til Anheier on 27.06.24.
//

import SwiftUI

struct ProfilePetsRow: View {
    @ObservedObject var vm: UserProfileViewModel
    @State var pet: Pet
    @State private var petType: PetType? = nil
    @State private var isShowingPetsSheet = false
    
    var body: some View {
        ZStack {
            HStack {
                Image(systemName: "pawprint.circle.fill")
                    .font(.title)
                    .foregroundStyle(Color(greenColorReverse!))
                Text(pet.name ?? "Tier nicht gefunden")
                    .fontWeight(.medium)
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
                Button(action: { isShowingPetsSheet.toggle() }) {
                    Image(systemName: "square.and.pencil")
                        .font(.title3)
                        .foregroundStyle(Color(greenColorReverse!))
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
    ProfilePetsRow(vm: UserProfileViewModel(userProfile: UserProfileViewModel.sampleData[0]), pet: UserProfileViewModel.sampleData[0].pets?.first ?? Pet())
}
