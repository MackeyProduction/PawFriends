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
    @State var advertisement: Advertisement
    @State private var isShowingAdvertisementSheet = false
    @State private var navigateToAdvertisementDetail = false
    
    func releaseDateToString(releaseDate: Temporal.DateTime) -> String {
        let relativeDateFormatter = DateFormatter()
        relativeDateFormatter.timeStyle = .none
        relativeDateFormatter.dateStyle = .medium
        relativeDateFormatter.locale = Locale(identifier: "de_DE")
        relativeDateFormatter.doesRelativeDateFormatting = true
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "dd.MM.yyyy"
        
        return timeFormatter.string(from: releaseDate.foundationDate)
    }
    
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
                            Text(releaseDateToString(releaseDate:advertisement.releaseDate ?? Temporal.DateTime(.distantPast)))
                                .padding(.trailing, 50)
                            Spacer()
                        }.foregroundStyle(Color(textColor!))
                    }
                }
                .navigationDestination(isPresented: $navigateToAdvertisementDetail) {
                    AdvertisementDetail(vm: vm, advertisement: $advertisement)}
                Spacer()
                Button(action: { isShowingAdvertisementSheet.toggle() }) {
                    Image(systemName: "square.and.pencil")
                        .font(.title3)
                        .foregroundStyle(Color(greenColorReverse!))
                }
            }
            .padding(.top, 8)
            .sheet(isPresented: $isShowingAdvertisementSheet) {
                NavigationStack {
                    ProfileAdvertisementSheet(vm: vm, advertisement: $advertisement)
                }
            }
        }
    }
}

#Preview {
    ProfileAdvertisementRow(vm: UserProfileViewModel(userProfile: UserProfileViewModel.sampleData[0]), advertisement: UserProfileViewModel.sampleData[0].advertisements?.first ?? Advertisement())
}
