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
    @ObservedObject var advertisementViewModel: AdvertisementViewModel
    //@Query private var ads: [AdvertisementViewModel]
    @State private var newAdvertisement: AdvertisementViewModel?
    
    @State private var searchText = ""

    @State private var likedItem: Bool = false
    @State private var heart: String = "heart"
    
    init(advertisementViewModel: AdvertisementViewModel, titleFilter: String = "") {
        self.advertisementViewModel = advertisementViewModel
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
                            ZStack {
                                NavigationLink(destination: AdvertisementDetail(advertisement: $item)) {
                                    HStack {
                                        //                                    Image(item.advertisementImages![0] ?? "TestImage1")
                                        //                                        .resizable()
                                        //                                        .frame(width: 80, height: 80)
                                        //                                        .clipShape(RoundedRectangle(cornerRadius: 10))
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
                                            //alignment: .topleading
                                        }.frame(width: .infinity, height: 100)
                                    }
                                }
//                                HStack{
//                                    Spacer()
//                                    Button(action: likeItem) {
//                                        //Group{
//                                            Label("", systemImage: heart)
//                                                .foregroundStyle(Color(mainTextColor!))
//                                                .frame(width: 50, alignment: .center)
//                                                .border(.green)
////                                        }.frame(width: 50, height: 50)
////                                            .border(.blue)
//                                    }
//                                }
//                                .border(.brown)
//                                Spacer()
                            }
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
        AdvertisementList(advertisementViewModel: AdvertisementViewModel(advertisements: AdvertisementViewModel.sampleData))
    }
}

#Preview("Empty List") {
    AdvertisementList(advertisementViewModel: AdvertisementViewModel(advertisements: AdvertisementViewModel.sampleData))
}
