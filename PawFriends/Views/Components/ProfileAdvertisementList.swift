//
//  ProfileAdvertisementList.swift
//  PawFriends
//
//  Created by Til Anheier on 28.06.24.
//

import SwiftUI

struct ProfileAdvertisementList: View {
    @ObservedObject var vm: UserProfileViewModel
    @ObservedObject var advertisementViewModel: AdvertisementViewModel
    @Binding var advertisements: [Advertisement]
    @State private var newAdvertisement: Advertisement = Advertisement()
    @State private var isShowingAdvertisementSheet = false
    @State var isMyProfile: Bool

    init(vm: UserProfileViewModel, advertisementViewModel: AdvertisementViewModel, advertisements: Binding<[Advertisement]> = Binding.constant([]), isMyProfile: Bool) {
        self.vm = vm
        self.advertisementViewModel = advertisementViewModel
        self._advertisements = advertisements
        self.isMyProfile = isMyProfile
    }
    
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Text("Anzeigen")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
                if isMyProfile {
                    Button(action: { isShowingAdvertisementSheet.toggle() }) {
                        Image(systemName: "plus.square")
                            .font(.title2)
                    }
                }
            }.padding(.bottom, 5)
            
            if !advertisements.isEmpty {
                ForEach($advertisements, id: \.id) { advertisement in
                    if isMyProfile {
                        ProfileAdvertisementRow(vm: vm, advertisementViewModel: advertisementViewModel, advertisement: advertisement, isMyProfile: true)
                    } else {
                        ProfileAdvertisementRow(vm: vm, advertisementViewModel: advertisementViewModel, advertisement: advertisement, isMyProfile: false)
                    }
                }
            } else {
                ContentUnavailableView {
                    Label("Keine Anzeigen vorhanden", systemImage: "pawprint")
                }
            }
        }
        .padding(.top, 5).padding(.bottom, 5)
        .sheet(isPresented: $isShowingAdvertisementSheet) {
            NavigationStack {
                ProfileAdvertisementSheet(vm: vm, advertisementViewModel: advertisementViewModel, advertisement: $newAdvertisement, isNew: true)
            }
        }
    }
}

#Preview {
    ProfileAdvertisementList(vm: UserProfileViewModel(userProfile: UserProfileViewModel.sampleData[0]), advertisementViewModel: AdvertisementViewModel(advertisements: AdvertisementViewModel.sampleData), isMyProfile: true)
}

#Preview("another profile") {
    ProfileAdvertisementList(vm: UserProfileViewModel(userProfile: UserProfileViewModel.sampleData[0]), advertisementViewModel: AdvertisementViewModel(advertisements: AdvertisementViewModel.sampleData), isMyProfile: false)
}
