//
//  AdvertisementList.swift
//  PawFriends
//
//  Created by Til Anheier on 09.06.24.
//

import SwiftUI
import SwiftData

struct AdvertisementList: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject var advertisementViewModel = AdvertisementViewModel()
    //@Query private var ads: [AdvertisementViewModel]
    @State private var newAdvertisement: AdvertisementViewModel?
    
    @State private var likedItem: Bool = false
    @State private var heart: String = "heart"
    
    init(titleFilter: String = "") {
        /*
         let predicate = #Predicate<AdvertisementViewModel> { ad in
         titleFilter.isEmpty || ad.title.localizedStandardContains(titleFilter)
         }
         
         _advertisementViewModel.$advertisements = Query(filter: predicate, sort: \AdvertisementViewModel.title)
         */
    }
    
    var body: some View {
        ZStack {
            Color(mainColor!)
                .edgesIgnoringSafeArea(.all)
            Group {
                if !advertisementViewModel.advertisements.isEmpty {
                    List {
                        ForEach($advertisementViewModel.advertisements, id: \.id) { $item in
                            //GeometryReader { geoRoot in
                            NavigationLink {
                                //                                AdvertisementDetail(advertisement: $item, geoRoot: geoRoot)
                                AdvertisementDetail(advertisement: $item)
                                    .toolbar {
                                        ToolbarItem(placement: .topBarTrailing) {
                                            RoundedRectangle(cornerRadius: 10)
                                                .frame(width: 75, height: 35)
                                                .foregroundStyle(.black)
                                                .opacity(0.4)
                                                .overlay(alignment: .center) {
                                                    HStack {
                                                        Button(action: likeItem) {
                                                            Label("Like Item", systemImage: heart)
                                                                .foregroundStyle(.white)
                                                        }
                                                        Button(action: shareItem) {
                                                            Label("Share Item", systemImage: "square.and.arrow.up")
                                                                .foregroundStyle(.white)
                                                        }
                                                        .padding(.bottom, 5)
                                                    }
                                                }
                                        }
                                    }
                            } label: {
                                Text(item.title ?? "")
                            }
                            .listRowBackground(Color(secondColor!))
                            //}
                        }.onDelete(perform: deleteItems)
                        
                    }.scrollContentBackground(.hidden)
                } else {
                    ContentUnavailableView {
                        Label("Keine Anzeigen gefunden", systemImage: "pawprint")
                    }
                }
            }
            .navigationTitle("Suche")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .task {
                //await advertisementViewModel.listAdvertisements()
            }
            .buttonStyle(.plain)
        }
    }
    
    private func likeItem() {
        if likedItem {
            heart = "heart"
            likedItem = false
        } else {
            heart = "heart.fill"
            likedItem = true
        }
    }
    
    private func shareItem(){
        
    }

    private func addItem() {
        /*withAnimation {
            let newItem = Advertisement(title: "New Item", timestamp: Date())
            modelContext.insert(newItem)
            newAdvertisement = newItem
        }*/
    }

    private func deleteItems(offsets: IndexSet) {
        /*withAnimation {
            for index in offsets {
                modelContext.delete(ads[index])
            }
        }*/
    }
}

#Preview {
    NavigationStack {
        AdvertisementList()
    }
}

#Preview("Empty List") {
    AdvertisementList()
}
