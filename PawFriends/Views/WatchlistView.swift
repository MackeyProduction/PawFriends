//
//  WatchlistView.swift
//  PawFriends
//
//  Created by Til Anheier on 23.06.24.
//

import SwiftUI
import Amplify

struct WatchlistView: View {
    @ObservedObject var userProfileViewModel: UserProfileViewModel
    @State private var watchList: [WatchList] = []
    @State private var advertisements: [Advertisement] = []
    
    var body: some View {
        Group {
            if let watchList = userProfileViewModel.userProfile?.watchLists, watchList.isLoaded, !watchList.isEmpty {
                List {
                    ForEach($advertisements, id: \.id) { advertisement in
                        NavigationLink(destination: AdvertisementDetail(vm: userProfileViewModel, advertisement: advertisement)) {
                            HStack {
                                Image("\(String(describing: advertisement.wrappedValue.advertisementImages?.first))")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                VStack(alignment: .leading) {
                                    Text("\(advertisement.wrappedValue.title ?? "Anzeige nicht gefunden")")
                                        .font(.headline)
                                    if let userProfile = userProfileViewModel.userProfile {
                                        Text("\(userProfile.location ?? "")")
                                            .font(.subheadline)
                                    }
                                    Text(releaseDateToString(releaseDate: advertisement.wrappedValue.releaseDate ?? Temporal.DateTime(.distantPast)))
                                        .font(.subheadline)
                                }
                                Spacer()
                                Button(action: {
                                    //                                if let index = ads.firstIndex(where: { $0.id == ad.id }) {
                                    //                                    ads.remove(at: index)
                                    //                                }
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                }
                
            } else {
                ContentUnavailableView {
                    Label("Keine Favoriten gefunden", systemImage: "heart")
                }
            }
        }
        .background(Color(mainColor!))
        .scrollContentBackground(.hidden)
        .onAppear {
            Task {
                do {
                    if let watchList = userProfileViewModel.userProfile?.watchLists, watchList.isLoaded {
                        self.advertisements = await getAdvertisements(watchList: userProfileViewModel.userProfile?.watchLists?.elements ?? [])
                    }
                }
            }
        }
    }
    
    func getAdvertisements(watchList: [WatchList]) async -> [Advertisement] {
        do {
            self.advertisements = []
            self.watchList = watchList
            for item in watchList {
                let advertisement = try await item.advertisement!
                let userProfile = try await item.userProfile!
                
                if userProfile.id == userProfileViewModel.userProfile?.id {
                    advertisements.append(advertisement)
                }
            }
        } catch {
            print("Could not fetch data.")
        }
        
        return advertisements
    }
    
    func releaseDateToString(releaseDate: Temporal.DateTime) -> String {
        let relativeDateFormatter = DateFormatter()
        relativeDateFormatter.timeStyle = .none
        relativeDateFormatter.dateStyle = .medium
        relativeDateFormatter.locale = Locale(identifier: "de_DE")
        relativeDateFormatter.doesRelativeDateFormatting = true
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        //let date = Date(timeIntervalSinceNow: -131231)
        let timeString = timeFormatter.string(from: releaseDate.foundationDate)
        let relativeDateString = relativeDateFormatter.string(from: releaseDate.foundationDate)
        let RelativeDateTimeString = relativeDateString+", "+timeString
        
        return RelativeDateTimeString
    }
}

#Preview {
    WatchlistView(userProfileViewModel: UserProfileViewModel(userProfile: UserProfileViewModel.sampleData[0]))
}
