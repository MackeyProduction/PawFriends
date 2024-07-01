//
//  DetailProfileInfos.swift
//  PawFriends
//
//  Created by Hanna Steffen on 01.07.24.
//

import SwiftUI
import Amplify

struct DetailProfileInfos: View {
    @ObservedObject var vm: UserProfileViewModel
    
    @State private var authorName: String? = nil
    @State private var tag: String? = "tag"
    @State private var tags: [Tag] = []
    @State private var tagCloud: [String] = []
    
    @State var title: String
    
    init(vm: UserProfileViewModel, title: String = "Anbieter") {
        self.vm = vm
        self.title = title
    }
    
    var body: some View {
        VStack {
            Text(title)  // alles am anbieter fixen (userprofile)
                .font(.title3)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 8)
            
            HStack {
                Image(systemName: "person.crop.square.fill")
                    .font(.system(size: 50))
                    .padding(.trailing, 2)
                    .foregroundColor(Color(firstColor!))
                //Text("Anna")
                Text("\(authorName ?? "")")
                    .font(.headline)
                
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                    Button(action: follow) {
                        Label("Folgen", systemImage: "person.badge.plus")
                    }
                    .foregroundStyle(Color(mainTextColor!))
                }
                .frame(width: 100, height: 40)
                .foregroundStyle(Color(secondColor!))
            }
            
            HStack {
                Image(systemName: "bookmark")
                    .font(.callout)
                    .frame(width: 10)
                //Text("Aktiv seit 19.09.19")
                Text("Aktiv seit: \(dateToString(releaseDate: vm.userProfile?.activeSince ?? Temporal.Date.now()))")
                    .font(.callout)
                Spacer()
            }
            .foregroundStyle(Color(textColor!))
            .padding(.top, 2)
            .padding(.bottom, 5)
            HStack {
                Image(systemName: "number.square")
                    .font(.callout)
                    .frame(maxWidth: 10, maxHeight: .infinity, alignment: .top)
                    .padding(.top, 9)
                //TagCloudView(tags: ["Nicht-Raucher","sportlich","Katzen-Kenner"])
                TagCloudView(tags: tagCloud)
            }
        }
        .onAppear {
            Task {
                do {
                    try await vm.userProfile?.tags?.fetch()
                    try await loadTagCloud()
                    self.authorName = await vm.getAuthorName()
                }
            }
            
        }
    }
    
    private func loadTagCloud() async throws {
        do {
            let tagItems = vm.userProfile?.tags?.elements
            for item in tagItems! {
                let tag = try await item.tag
                self.tagCloud.append(tag?.description ?? "")
            }
        } catch {
            print("Could not fetch tags for tag cloud.")
        }
    }
    
    func dateToString(releaseDate: Temporal.Date) -> String {
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
    
    private func follow() {
        
    }
}

#Preview {
    DetailProfileInfos(vm: UserProfileViewModel(userProfile: UserProfileViewModel.sampleData[0]))
}
