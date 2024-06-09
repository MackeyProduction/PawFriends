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
    @Query private var ads: [Advertisement]
    
    @State private var newAdvertisement: Advertisement?
    
    init(titleFilter: String = "") {
        let predicate = #Predicate<Advertisement> { ad in
            titleFilter.isEmpty || ad.title.localizedStandardContains(titleFilter)
        }
            
        _ads = Query(filter: predicate, sort: \Advertisement.title)
    }
    
    var body: some View {
        Group {
            if !ads.isEmpty {
                List {
                    ForEach(ads) { item in
                        NavigationLink {
                            Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                        } label: {
                            Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
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
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Advertisement(title: "New Item", timestamp: Date())
            modelContext.insert(newItem)
            newAdvertisement = newItem
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(ads[index])
            }
        }
    }
}

#Preview {
    AdvertisementList()
        .modelContainer(for: Advertisement.self, inMemory: true)
}
