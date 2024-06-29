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
    
    @State private var searchText = ""

    
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
                                HStack {
//                                    Image(Image(item.advertisementImages![0]!)
//                                        .resizable()
//                                        .frame(width: 80, height: 80)
//                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                    Image("TestImage2")
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        
                                    VStack {
                                        Text(item.title ?? "")
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        HStack{
                                            Text(item.description ?? "")
                                            Spacer()
                                        }.frame(maxWidth: .infinity, maxHeight: 50, alignment: .top)
                                        Spacer()
                                        //alignment: .topleading
                                    }.frame(width: .infinity, height: 100)
                                }
                            }
                            .listRowBackground(Color(mainColor!))
                            //}
                        }.onDelete(perform: deleteItems)
                        
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
        }.searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Suche")
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
