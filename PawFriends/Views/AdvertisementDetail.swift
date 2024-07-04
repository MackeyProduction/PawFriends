//
//  AdvertisementDetail.swift
//  PawFriends
//
//

import SwiftUI
import Amplify
import PhotosUI


struct AdvertisementDetail: View {
    @ObservedObject var vm: UserProfileViewModel
    @Binding var advertisement: Advertisement
    @State var isNew: Bool
    
    @State private var likedItem: Bool = false
    @State private var heart: String = "heart"
    
    @StateObject private var viewModel = PhotoPickerViewModel()
    @State var imageSelections: [PhotosPickerItem] = []
    //var geoRoot: GeometryProxy
    
    @State private var title: String = ""
    @State private var releaseDate: Date = Date()
    @State private var tags: String = "tag"
    @State private var tagCloud: [String] = []
    @State private var description: String = ""
    @State private var advertisementUserProfile: UserProfile? = nil
    @State private var isShowingMessageSheet = false
    @State private var chatMessage: String? = ""
    
    @Environment(\.dismiss) private var dismiss
    
    
    init(vm: UserProfileViewModel, advertisement: Binding<Advertisement>, isNew: Bool = false) {
        self.vm = vm
        self._advertisement = advertisement
        self.isNew = isNew
        self.title = ""
        self.releaseDate = Date()
        self.description = ""
    }
    
    func stringToUiimages(strings: [String?]?) -> [UIImage]{
        var uiimages: [UIImage] = []
        for string in strings! {
            let image: Image = Image(string!)
            uiimages.append(image.asUIImage())
        }
        return uiimages
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
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                if advertisement.advertisementImages != nil {
                    let images: [UIImage] = stringToUiimages(strings: advertisement.advertisementImages)
                    //SliderView(images: images)
                    Image(uiImage: images[0])
                        .resizable()
                        .scaledToFill()
                        .frame(height: 270, alignment: .top)
                        .clipped()
                    //                        ZStack {
                    //                            GeometryReader { geo in
                    //                                let yOffset = (geoRoot.safeAreaInsets.top - geo.safeAreaInsets.top) / 2
                    //                                TabView {
                    //                                    Text("lol")
                    //                                    //.offset(y: yOffset)
                    //                                        .border(.brown)
                    //                                    Image(uiImage: images[0])
                    //                                        .resizable()
                    //                                        .scaledToFill()
                    //                                        .frame(height: 340, alignment: .top)
                    //                                        .clipped()
                    //                                    //.offset(y: yOffset)
                    //                                    Text("lol2")
                    //                                }
                    //                                .tabViewStyle(.page(indexDisplayMode: .always))
                    //                                .frame(maxWidth: .infinity, maxHeight: 275, alignment: .top)
                    //                                .border(.red)
                    //                                //SwipeView(images: images)
                    //                                //SliderView(images: images)
                    //                            }
                    //                        }.edgesIgnoringSafeArea(.top)
                    //                        SliderView(images: stringToUiimages(strings: advertisement.advertisementImages))
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: 250, alignment: .center)
                        .clipped()
                        .opacity(0.2)
                }
                
                VStack(spacing: 5) {
                    Text(advertisement.title ?? "Kein Titel")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        Image(systemName: "eye")
                            .font(.callout)
                            .frame(width: 10)
                            .padding(.trailing, 5)
                        Text("\(advertisement.visitor ?? 0)")
                        Spacer()
                    }
                    .foregroundStyle(Color(textColor!))
                    .padding(.top, 5)
                    
                    HStack {
                        Image(systemName: "calendar")
                            .font(.callout)
                            .frame(width: 10)
                            .padding(.trailing, 5)
                        Text(releaseDateToString(releaseDate:advertisement.releaseDate ?? Temporal.DateTime(.distantPast)))
                        Spacer()
                        Image(systemName: "mappin.and.ellipse")
                            .font(.callout)
                            .frame(width: 10)
                            .padding(.trailing, 5)
                        Text(vm.userProfile?.location ?? "")
                    }
                    .foregroundStyle(Color(textColor!))
                    
                    HStack {
                        Image(systemName: "number.square")
                            .font(.headline)
                            .frame(maxWidth: 10, maxHeight: .infinity, alignment: .top)
                            .padding(.trailing, 5)
                            .padding(.top, 4)
                        
                        //var tagCloud = ["Indoor", "Erdgeschoss", "Katze", "Nicht-Raucherhaushalt", "Einmalig"]
                        TagCloudView(tags: tagCloud)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 70, alignment: .top)
                    .padding(.top, 15)
                    .padding(.bottom, 10)
                    
                    Divider()
                        .background(Color(textColor!))
                    
                    Text(advertisement.description ?? "Keine Beschreibung")
                        .font(.callout)
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                }
                .padding(.leading)
                .padding(.trailing)
                
                Divider()
                    .background(Color(textColor!))
                
                if let up = advertisementUserProfile {
                    DetailProfileInfos(vm: vm, title: "Anbieter", authorId: up.author ?? "")
                        .padding(.top, 10)
                        .padding(.bottom, 20)
                        .padding(.leading)
                        .padding(.trailing)
                } else {
                    ContentUnavailableView {
                        Label("Anbieter nicht gefunden", systemImage: "person")
                    }
                }
                
                Divider()
                    .background(Color(textColor!))
                
                Button(action: { isShowingMessageSheet.toggle() }) {
                    Label("Nachricht", systemImage: "message")
                        .font(.title2)
                        .foregroundStyle(Color(mainTextColor!))
                }
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color(greenColor!)))
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
            //.edgesIgnoringSafeArea(.top)
        }
        .background(Color(mainColor!))
        .edgesIgnoringSafeArea(.top)
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
                            .padding(.trailing, 10)
                        }
                    }
            }
        }
        .sheet(isPresented: $isShowingMessageSheet) {
            Form {
                Section {
                    HStack {
                        Image(systemName: "person.crop.square.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(Color(firstColor!))
                        
                        Text("\(advertisement.author ?? "Anbieter nicht gefunden")")
                            .font(.largeTitle)
                    }.padding(.top)
                }
                
                Section {
                    Text("Nachricht")
                    TextField("", text: Binding(
                        get: { chatMessage ?? "" },
                        set: { chatMessage = $0 }
                    ), axis: .vertical)
                        .autocorrectionDisabled()
                        .lineLimit(9...9)
                }
                .listRowBackground(Color(thirdColor!))
                
                Section(footer:
                            HStack {
                    Spacer()
                    Button(action: createChat) {
                        Label("Senden", systemImage: "message")
                            .font(.title2)
                            .foregroundStyle(Color(mainTextColor!))
                    }
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color(greenColor!)))
                    Spacer()
                }
                ) {
                    EmptyView()
                }
            }
            .scrollContentBackground(.hidden)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen", action: { dismiss() })
                }
            }
        }
        .onReceive(vm.$userProfile, perform: { _ in
            Task {
                do {
                    try await advertisement.tags?.fetch()
                    try await vm.userProfile?.watchLists?.fetch()
                    try await loadTagCloud()
                    await fetchLikeItem()
                    await updateVisitor()
                    self.advertisementUserProfile = try await advertisement.userProfile
                }
            }
        })
        
    }
    
    private func toggleLikeItem() {
        likedItem = !likedItem
        heart = likedItem ? "heart.fill" : "heart"
    }
    
    private func likeItem() {
        toggleLikeItem()
        
        Task {
            if likedItem {
                await vm.createWatchListItem(userProfile: vm.userProfile!, advertisement: advertisement)
            } else {
                if let watchListItem = await vm.fetchWatchListItem(userProfile: vm.userProfile!, advertisement: advertisement) {
                    await vm.deleteWatchListItem(watchList: watchListItem)
                }
            }
        }
    }
    
    private func fetchLikeItem() async {
        if let watchListItem = await vm.fetchWatchListItem(userProfile: vm.userProfile!, advertisement: advertisement) {
            toggleLikeItem()
        }
    }
    
    private func updateVisitor() async {
        advertisement.visitor = 1 // TODO: muss noch gefixt werden
        await vm.updateAdvertisement(userProfile: vm.userProfile!, advertisement: advertisement)
    }
    
    private func shareItem(){
        
    }
    
    private func saveAdvertisement() {
        advertisement.title = title.isEmpty ? nil : title
        advertisement.releaseDate = Temporal.DateTime(releaseDate)
    }
    
    private func createOrUpdate() {
        Task {
            do {
                // check if we have a new or an existing advertisement
                if isNew {
                    await vm.createAdvertisement(userProfile: vm.userProfile!, advertisement: advertisement)
                } else {
                    await vm.updateAdvertisement(userProfile: vm.userProfile!, advertisement: advertisement)
                }
                
                // reload advertisements
                try await vm.userProfile?.advertisements?.fetch()
                
                dismiss()
            }
        }
    }
    
    private func loadTagCloud() async throws {
        do {
            if let tagItems = advertisement.tags?.elements {
                for item in tagItems {
                    let tag = try await item.tag
                    self.tagCloud.append(tag?.description ?? "")
                }
            }
        } catch {
            print("Could not fetch tags for tag cloud.")
        }
    }
    
    private func createChat() {
        Task {
            do {
                if let author = advertisementUserProfile?.author, let up = vm.userProfile {
                    await vm.createChat(message: chatMessage ?? "", recipient: author.uppercased(), userProfile: up, advertisement: advertisement)
                    
                    vm.userProfile?.chats = List(elements: await vm.fetchChats(userProfile: vm.userProfile!))
                }
                
                dismiss()
            }
        }
    }
}


#Preview {
    NavigationStack {
        @State var advertisement = UserProfileViewModel.sampleData[0].advertisements?.first ?? Advertisement()
        AdvertisementDetail(vm: UserProfileViewModel(userProfile: UserProfileViewModel.sampleData[0]), advertisement: $advertisement)
    }
}



