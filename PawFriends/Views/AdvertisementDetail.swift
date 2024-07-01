//
//  AdvertisementDetail.swift
//  PawFriends
//
//

import SwiftUI
import Amplify
//import SwiftData
import PhotosUI


struct AdvertisementDetail: View {
    //@Query(sort: \Advertisement.title) private var ads: [Advertisement]
    //@ObservedObject var vm: UserProfileViewModel
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
    //@State private var tags: [String] = []
    @State private var tags: String = "tag"
    private var tagOptions: [String] = ["Einmalig","Regelmäßig","Katze","Hund","Vögel","Pferd","Hasenartig","Nagetier","Andere Tiere","Fische","Erdgeschoss","Barrierefrei","Allergiker geeignet","Gassi gehen","Outdoor","Indoor"]
    @State private var description: String = ""
    
    @Environment(\.dismiss) private var dismiss
    
    
    init(vm: UserProfileViewModel, advertisement: Binding<Advertisement>, isNew: Bool = false) {
        self.vm = vm
        self._advertisement = advertisement
        self.isNew = isNew
        self.title = ""
        self.releaseDate = Date()
        self.description = ""
    }
//    init(advertisement: Binding<Advertisement>, isNew: Bool = false, geoRoot: GeometryProxy) {
//        self._advertisement = advertisement
//        self.geoRoot = geoRoot
//        self.isNew = isNew
//        self.title = ""
//        self.releaseDate = Date()
//    }
    
    //    func dataToUiimages(data: [Data]) -> [UIImage]{ // images to uiimages?
    //        var uiimages: [UIImage] = []
    //        for image in data {
    //            uiimages.append(UIImage(data: image)!)
    //        }
    //        return uiimages
    //    }
    
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
        //GeometryReader { g in
        if !isNew {
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
                            Text("47441 Moers") //später fixen: advertisement.userProfile.location oder so
                        }
                        .foregroundStyle(Color(textColor!))
                        
                        HStack {
                            Image(systemName: "number.square")
                                .font(.headline)
                                .frame(maxWidth: 10, maxHeight: .infinity, alignment: .top)
                                .padding(.trailing, 5)
                                .padding(.top, 4)
                            
                            //Wichtig: TagCloudView bei >2 Reihen fixen
                            let tags = ["Einmalig","Indoor","Katze","Barrierefrei",] // tags aus anzeige wie verwenden?
                            TagCloudView(tags: tags)
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
                    
                    DetailProfileInfos(vm: vm, title: "Anbieter")
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                    .padding(.leading)
                    .padding(.trailing)
                    
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
        } else {
            VStack(spacing: 10) {
                if viewModel.selectedImages.isEmpty {
                    ZStack {
                        Rectangle()
                            .fill(Color(secondColor!))
                            .frame(maxWidth: .infinity, maxHeight: 270)
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: 250, alignment: .center)
                            .clipped()
                            .foregroundStyle(Color(textColor!))
                            .opacity(0.2)
                            .overlay(alignment: .bottomTrailing) {
                                PhotosPicker(selection: $viewModel.imageSelections,
                                             matching: .images,
                                             photoLibrary: .shared()) {
                                    PickPhotoButton()
                                        .padding(.bottom, 5)
                                        .padding(.trailing, 5)
                                }
                                             .buttonStyle(.borderless)
                            }
                    }
                    .frame(height: 270)
                } else {
                    //SwipeView(images: viewModel.selectedImages)
                    Image(uiImage: viewModel.selectedImages[0])
                        .resizable()
                        .scaledToFill()
                        .frame(height: 270, alignment: .top)
                        .clipped()
                        .overlay(alignment: .bottomTrailing) {
                            PhotosPicker(selection: $viewModel.imageSelections,
                                         matching: .images,
                                         photoLibrary: .shared()) {
                                PickPhotoButton()
                                    .padding(.bottom, 5)
                                    .padding(.trailing, 5)
                            }
                                         .buttonStyle(.borderless)
                        }
                }
                
                Form {
                    Section {
                        //Text("Titel")
                        TextField("Titel", text: Binding(
                            get: { advertisement.title ?? "" },
                            set: { advertisement.title = $0 }
                        ), axis: .vertical)
                            .autocorrectionDisabled()
                    }
                    .listRowBackground(Color(thirdColor!))
                    
        //            Section { //Multi select, Kategorien sortiert
        //                Picker("Tags", selection: $tags) {
        //                    ForEach(tagOptions, id: \.self) {
        //                        Text($0)
        //                    }
        //                }//.pickerStyle()
        //            }
        //            .listRowBackground(Color(thirdColor!))
                    
                    Section {
                        Text("Beschreibung")
                        TextField("", text: Binding(
                            get: { advertisement.description ?? "" },
                            set: { advertisement.description = $0 }
                        ), axis: .vertical)
                            .autocorrectionDisabled()
                            .lineLimit(9...9)
                    }
                    .listRowBackground(Color(thirdColor!))
                                        
                    Section(footer:
                                HStack {
                        Spacer()
                        Button(action: createOrUpdate) {
                            Text("Veröffentlichen")
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
                }.scrollContentBackground(.hidden)
                    //.navigationTitle(isNew ? "Anzeige hinzufügen" : "Anzeige bearbeiten")
                    .toolbar {
//                        ToolbarItem(placement: .confirmationAction) {
//                            Button("Done", action: createOrUpdate)
//                        }
                        
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Abbrechen", action: { dismiss() })
                        }
                    }
                
//                Form {
//                    Section {
//                        //Text("Titel")
//                        TextField("Titel", text: $title)
//                            .autocorrectionDisabled()
//                    }
//                    .listRowBackground(Color(thirdColor!))
//                    
//                    Section { //Multi select, Kategorien sortiert
//                        Picker("Tags", selection: $tags) {
//                            ForEach(tagOptions, id: \.self) {
//                                Text($0)
//                            }
//                        }//.pickerStyle()
//                    }
//                    .listRowBackground(Color(thirdColor!))
//                    
//                    Section {
//                        Text("Beschreibung")
//                        TextField("", text: $description, axis: .vertical)
//                            .autocorrectionDisabled()
//                            .lineLimit(9...9)
//                    }
//                    .listRowBackground(Color(thirdColor!))
//                                        
//                    Section(footer:
//                                HStack {
//                        Spacer()
//                        Button(action: {}) {
//                            Text("Veröffentlichen")
//                                .font(.title2)
//                                .foregroundStyle(Color(mainTextColor!))
//                        }
//                        .padding(10)
//                        .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color(greenColor!)))
//                        Spacer()
//                    }
//                    ) {
//                        EmptyView()
//                    }
//                }
//                //.frame(width: g.size.width, height: g.size.height-150, alignment: .center)
//                .frame(height: 560) //dynamische höhe machen
//                .scrollContentBackground(.hidden)
//                .toolbar {
//                    ToolbarItem(placement: .cancellationAction) {
//                        Button("Abbrechen") {
//                            //     modelContext.delete(advertisement)
//                            dismiss()
//                        }.foregroundStyle(Color(mainTextColor!))
//                    }
//                }
                //.navigationTitle(isNew ? "Neue Anzeige" : "Anzeige")
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
            .background(Color(mainColor!))
            .edgesIgnoringSafeArea(.top)
            //}
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
    
    private func follow() {
        
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
}


#Preview {
    NavigationStack {
        @State var advertisement = UserProfileViewModel.sampleData[0].advertisements?.first ?? Advertisement()
        AdvertisementDetail(vm: UserProfileViewModel(userProfile: UserProfileViewModel.sampleData[0]), advertisement: $advertisement)
    }
//    NavigationStack {
//        @State var sampleAdvertisement = AdvertisementViewModel.sampleData[0]
//        GeometryReader { previewGeo in
//            AdvertisementDetail(advertisement: $sampleAdvertisement)
////            AdvertisementDetail(advertisement: $sampleAdvertisement, geoRoot: previewGeo)
//        }
//    }
}

#Preview("New Advertisement") {
    NavigationStack {
        @State var advertisement = UserProfileViewModel.sampleData[0].advertisements?.first ?? Advertisement()
        AdvertisementDetail(vm: UserProfileViewModel(userProfile: UserProfileViewModel.sampleData[0]), advertisement: $advertisement, isNew: true)
    }
//    NavigationStack {
//        @State var sampleAdvertisement = AdvertisementViewModel.sampleData[0]
//        GeometryReader { previewGeo in
//            AdvertisementDetail(advertisement: $sampleAdvertisement, isNew: true)
//                .navigationBarTitleDisplayMode(.inline)
//        }
//    }
}


  
