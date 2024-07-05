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
    @State private var followIcon: String = "person.badge.plus"
    @State private var followed: Bool = false
    @State private var followLabel: String = "Folgen"
    
    @State var title: String
    @State var authorId: String
    
    init(vm: UserProfileViewModel, title: String = "Anbieter", authorId: String = "") {
        self.vm = vm
        self.title = title
        self.authorId = authorId
    }
    
    var body: some View {
        VStack {
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 8)
            
            HStack {
                Image(systemName: "person.crop.square.fill")
                    .font(.system(size: 50))
                    .padding(.trailing, 2)
                    .foregroundColor(Color(firstColor!))
                Text("\(authorName ?? "")")
                    .font(.headline)
                
                Spacer()
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                    Button(action: follow) {
                        Label(followLabel, systemImage: followIcon)
                    }
                    .foregroundStyle(Color(mainTextColor!))
                }
                .frame(width: 120, height: 40)
                .foregroundStyle(Color(secondColor!))
            }
            
            HStack {
                Image(systemName: "bookmark")
                    .font(.callout)
                    .frame(width: 10)
                Text("Aktiv seit: \(DateFormatHelper.dateToString(date: vm.userProfile?.activeSince ?? Temporal.Date.now()))")
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
                TagCloudView(tags: tagCloud)
            }
        }
        .onAppear {
            Task {
                do {
                    try await vm.userProfile?.tags?.fetch()
                    try await loadTagCloud()
                    await fetchFollow()
                    
                    if vm.userProfile?.author == self.authorId {
                        self.authorName = await vm.getAuthorName()
                    } else {
                        self.authorName = self.authorId
                    }
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
    
    private func toggleFollow() {
        followed = !followed
        followIcon = followed ? "person.fill.checkmark" : "person.badge.plus"
        followLabel = followed ? "Entfolgen" : "Folgen"
    }
    
    private func follow() {
        toggleFollow()
        
        Task {
            let userProfile = await vm.getProfile(id: UUID(uuidString: authorId)!)
            guard userProfile != nil else {
                print("User could not be found.")
                return
            }
            
            if followed {
                await vm.createFollows(follower: vm.userProfile!, followed: userProfile!)
            } else {
                if let userProfileFollower = await vm.fetchFollow(follower: vm.userProfile!, followed: userProfile!) {
                    await vm.deleteFollows(userProfileFollower: userProfileFollower)
                }
            }
        }
    }
    
    private func fetchFollow() async {
        let userProfile = await vm.getProfile(id: UUID(uuidString: authorId)!)
        if let _ = await vm.fetchFollow(follower: vm.userProfile!, followed: userProfile!) {
            toggleFollow()
        }
    }
}

#Preview {
    DetailProfileInfos(vm: UserProfileViewModel(userProfile: UserProfileViewModel.sampleData[0]))
}
