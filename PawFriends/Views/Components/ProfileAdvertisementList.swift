//
//  ProfileAdvertisementList.swift
//  PawFriends
//
//  Created by Til Anheier on 28.06.24.
//

import SwiftUI

struct ProfileAdvertisementList: View {
    @ObservedObject var vm: UserProfileViewModel
    @State var advertisements: [Advertisement]
    @State private var newAdvertisement: Advertisement = Advertisement()
    @State private var isShowingAdvertisementSheet = false
   // @State private var navigateToAdvertisementDetail = false

    
    init(vm: UserProfileViewModel, advertisements: [Advertisement] = []) {
        self.vm = vm
        self.advertisements = advertisements
    }
    
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Text("Anzeigen")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
                Button(action: { isShowingAdvertisementSheet.toggle() }) {
                    Image(systemName: "plus.square")
                        .font(.title2)
                }
//                Button(action: {
//                    navigateToAdvertisementDetail = true
//                }) {
//                    Label("", systemImage: "plus.square")
//                }
//                .padding(.trailing, -8)
//                .font(.title2)
//                .navigationDestination(isPresented: $navigateToAdvertisementDetail) {
//                    AdvertisementDetail(vm: vm, advertisement: $newAdvertisement, isNew: true)
//                               }
            }.padding(.bottom, 5)
            
            if !advertisements.isEmpty {
                ForEach(advertisements, id: \.id) { advertisement in
                    ProfileAdvertisementRow(vm: vm, advertisement: advertisement)
                }
            }
        }
        .padding(.top, 5).padding(.bottom, 5)
//        .sheet(isPresented: $isShowingAdvertisementSheet) {
//            NavigationStack {
//                ProfileAdvertisementSheet(vm: vm, advertisement: $newAdvertisement, isNew: true)
//            }
//        }
    }
}

#Preview {
    ProfileAdvertisementList(vm: UserProfileViewModel(userProfile: UserProfileViewModel.sampleData[0]))
}
