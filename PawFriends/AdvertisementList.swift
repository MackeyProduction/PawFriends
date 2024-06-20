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
    
    init(titleFilter: String = "") {
        /*
        let predicate = #Predicate<AdvertisementViewModel> { ad in
            titleFilter.isEmpty || ad.title.localizedStandardContains(titleFilter)
        }
            
        _advertisementViewModel.$advertisements = Query(filter: predicate, sort: \AdvertisementViewModel.title)
         */
    }
    
    var body: some View {
        Group {
            if !advertisementViewModel.advertisements.isEmpty {
                List {
<<<<<<< Updated upstream
                    ForEach(advertisementViewModel.advertisements, id: \.id) { item in
                        NavigationLink {
                            Text("Item at \(String(describing: item.title))")
                        } label: {
                            Text(item.title ?? "")
=======
                    ForEach(ads) { advertisement in
                        NavigationLink {
                            AdvertisementDetail(advertisement: advertisement)
                        } label: {
                            Text(advertisement.title)
                            //Text(advertisement.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
>>>>>>> Stashed changes
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
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
            .modelContainer(SampleData.shared.modelContainer)
    }
}

#Preview("Empty List") {
    AdvertisementList()
}
