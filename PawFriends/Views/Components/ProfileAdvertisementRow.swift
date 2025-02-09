//
//  ProfileAdvertisementRow.swift
//  PawFriends
//
//  Created by Til Anheier on 28.06.24.
//

import SwiftUI
import Amplify

struct ProfileAdvertisementRow: View {
    @ObservedObject var vm: UserProfileViewModel
    @ObservedObject var advertisementViewModel: AdvertisementViewModel
    @Binding var advertisement: Advertisement
    @State private var isShowingAdvertisementSheet = false
    @State private var navigateToAdvertisementDetail = false
    @State var isMyProfile: Bool
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    navigateToAdvertisementDetail = true
                }) {
                    Image(systemName: "photo.fill")
                        .font(.system(size: 70))
                        .foregroundStyle(Color(greenColorReverse!))
                        .padding(-8)
                    VStack {
                        HStack {
                            Text(advertisement.title ?? "")
                                .fontWeight(.medium)
                            Spacer()
                            
                        }
                        HStack {
                            Image(systemName: "calendar")
                                .font(.callout)
                                .frame(width: 10)
                                .padding(.leading, 5)
                            Text(DateFormatHelper.releaseDateToString(releaseDate:advertisement.releaseDate ?? Temporal.DateTime(.distantPast)))
                                .padding(.trailing, 50)
                            Spacer()
                        }.foregroundStyle(Color(textColor!))
                    }
                }
                .navigationDestination(isPresented: $navigateToAdvertisementDetail) {
                    AdvertisementDetail(vm: vm, advertisement: $advertisement)}
                Spacer()
                if isMyProfile {
                    Button(action: { isShowingAdvertisementSheet.toggle() }) {
                        Image(systemName: "square.and.pencil")
                            .font(.title3)
                            .foregroundStyle(Color(greenColorReverse!))
                    }
                }
            }
            .padding(.top, 8)
            .sheet(isPresented: $isShowingAdvertisementSheet) {
                NavigationStack {
                    ProfileAdvertisementSheet(vm: vm, advertisementViewModel: advertisementViewModel, advertisement: $advertisement)
                }
            }
        }
    }
}

#Preview {
    ProfileAdvertisementRow(vm: UserProfileViewModel(userProfile: UserProfileViewModel.sampleData[0]), advertisementViewModel: AdvertisementViewModel(advertisements: AdvertisementViewModel.sampleData), advertisement: Binding.constant(UserProfileViewModel.sampleData[0].advertisements?.first ?? Advertisement()), isMyProfile: true)
}

#Preview ("another profile") {
    ProfileAdvertisementRow(vm: UserProfileViewModel(userProfile: UserProfileViewModel.sampleData[0]), advertisementViewModel: AdvertisementViewModel(advertisements: AdvertisementViewModel.sampleData), advertisement: Binding.constant(UserProfileViewModel.sampleData[0].advertisements?.first ?? Advertisement()), isMyProfile: false)
}
