//
//  AdvertisementList.swift
//  PawFriends
//
//  Created by Til Anheier on 09.06.24.
//

import SwiftUI
import SwiftData

struct AdvertisementList: View {
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    @ObservedObject var advertisementViewModel: AdvertisementViewModel
    @State private var newAdvertisement: Advertisement = Advertisement()
    @State private var searchText = ""
    @State private var isShowingAdvertisementSheet = false
    
    init(vm: UserProfileViewModel, advertisementViewModel: AdvertisementViewModel, titleFilter: String = "") {
        self.userProfileViewModel = vm
        self.advertisementViewModel = advertisementViewModel
    }
    
    var body: some View {
        ZStack {
            Color(mainColor!)
                .edgesIgnoringSafeArea(.all)
            Group {
                if !advertisementViewModel.advertisements.isEmpty {
                    List {
                        ForEach($advertisementViewModel.advertisements, id: \.id) { $item in
                            ZStack {
                                NavigationLink(destination: AdvertisementDetail(vm: userProfileViewModel, advertisement: $item)) {
                                    HStack {
                                        Image("TestImage2")
                                            .resizable()
                                            .frame(width: 100, height: 100)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                        
                                        VStack {
                                            HStack {
                                                Text(item.title ?? "")
                                                    .font(.title3)
                                                    .fontWeight(.semibold)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                            }
                                            HStack{
                                                Text(item.description ?? "")
                                                Spacer()
                                            }.frame(maxWidth: .infinity, maxHeight: 50, alignment: .top)
                                            Spacer()
                                        }.frame(width: .infinity, height: 100)
                                    }
                                }
                            }
                        }
                        
                    }.scrollContentBackground(.hidden)
                    .frame( maxWidth: .infinity)
                    .listStyle(GroupedListStyle())
                    
                    
                } else {
                    ContentUnavailableView {
                        Label("Keine Anzeigen gefunden", systemImage: "pawprint")
                    }
                }
            }
            .navigationTitle("Anzeigen")
            .toolbar {
                ToolbarItem {
                    Button(action: { isShowingAdvertisementSheet.toggle() }) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $isShowingAdvertisementSheet) {
                NavigationStack {
                    AdvertisementSheet(advertisementViewModel: advertisementViewModel, userProfile: userProfileViewModel.userProfile, advertisement: $newAdvertisement, isNew: true)
                }
            }
            .task {
                await advertisementViewModel.listAdvertisements()
            }
            .buttonStyle(.plain)
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Suche")
        .onChange(of: $searchText) {
            Task {
                if searchText == "" {
                    await advertisementViewModel.listAdvertisements()
                }
                
                advertisementViewModel.advertisements = advertisementViewModel.advertisements.filter { ad in
                    return ad.title!.starts(with: searchText)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AdvertisementList(vm: UserProfileViewModel(userProfile: UserProfileViewModel.sampleData[0]), advertisementViewModel: AdvertisementViewModel(advertisements: AdvertisementViewModel.sampleData))
    }
}

#Preview("Empty List") {
    AdvertisementList(vm: UserProfileViewModel(userProfile: UserProfileViewModel.sampleData[0]), advertisementViewModel: AdvertisementViewModel(advertisements: AdvertisementViewModel.sampleData))
}
