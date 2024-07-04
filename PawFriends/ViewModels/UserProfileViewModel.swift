//
//  UserProfileViewModel.swift
//  PawFriends
//
//  Created by Til Anheier on 22.06.24.
//

import Foundation
import Amplify
import class Amplify.List

@MainActor
class UserProfileViewModel: ObservableObject {
    @Published var userProfile: UserProfile? = nil
    
    init(userProfile: UserProfile? = nil) {
        self.userProfile = userProfile
    }
    
    func getCurrentProfile() async {
        let userAttributes = await fetchAttributes()
        let userId = userAttributes.first(where: { $0.key.rawValue == "sub" })?.value
        
        if let uId = userId, let uuid = UUID(uuidString: uId) {
            self.userProfile = await getProfile(id: uuid)
        }
    }
    
    func getAuthorName() async -> String? {
        let userAttributes = await fetchAttributes()
        return userAttributes.first(where: { $0.key == .preferredUsername })?.value
    }
    
    func getProfile(id: UUID) async -> UserProfile? {
        var userProfileResult: UserProfile? = nil
        let request = GraphQLRequest<UserProfile>.get(UserProfile.self, byId: id.uuidString)
        
        do {
            let result = try await Amplify.API.query(request: request)
            switch result {
            case .success(let userProfile):
                guard let userProfile = userProfile else {
                    print("Could not find user profile")
                    return nil
                }
                print("Successfully retrieved user profile: \(userProfile)")
                userProfileResult = userProfile
            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
            }
        } catch let error as APIError {
            print("Failed to query user profile: ", error)
        } catch {
            print("Unexpected error: \(error)")
        }
        
        return userProfileResult
    }
    
    func fetchAttributes() async -> [AuthUserAttribute] {
        do {
            return try await Amplify.Auth.fetchUserAttributes()
        } catch let error as AuthError{
            print("Fetching user attributes failed with error \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
        return []
    }
    
    func createProfile(userProfile: UserProfile) async {
        Task {
            do {
                if let uuid = UUID(uuidString: userProfile.id) {
                    self.userProfile = await getProfile(id: uuid)
                    guard self.userProfile == nil else {
                        print("User already exists")
                        return
                    }
                }
                
                let result = try await Amplify.API.mutate(request: .create(userProfile, authMode: .amazonCognitoUserPools))
                switch result {
                case .success(let userProfile):
                    print("Successfully created user profile: \(userProfile)")
                case .failure(let error):
                    print("Got failed result with \(error.errorDescription)")
                }
            } catch let error as APIError {
                print("Failed to create user profile: ", error)
            } catch {
                print("Unexpected error: \(error)")
            }
        }
    }
    
    func updateProfile(userProfile: UserProfile) async {
        do {
            let result = try await Amplify.API.mutate(request: .update(userProfile, authMode: .amazonCognitoUserPools))
            switch result {
            case .success(let userProfile):
                print("Successfully updated user profile: \(userProfile)")
            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
            }
        } catch let error as APIError {
            print("Failed to update user profile: ", error)
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func createChat(message: String, recipient: String, userProfile: UserProfile, advertisement: Advertisement) async {
        do {
            let newChat = Chat(message: message, recipient: recipient, userProfile: userProfile, advertisement: advertisement)
            let result = try await Amplify.API.mutate(request: .create(newChat, authMode: .amazonCognitoUserPools))
            switch result {
            case .success(let chat):
                print("Successfully created chat: \(chat)")
            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
            }
        } catch let error as APIError {
            print("Failed to create chat: ", error)
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func updateChat(chat: Chat) {
        Task {
            do {
                let result = try await Amplify.API.mutate(request: .update(chat))
                switch result {
                case .success(let chat):
                    print("Successfully updated chat: \(chat)")
                case .failure(let error):
                    print("Got failed result with \(error.errorDescription)")
                }
            } catch let error as APIError {
                print("Failed to updated chat: ", error)
            } catch {
                print("Unexpected error: \(error)")
            }
        }
    }
    
    func createAdvertisement(userProfile: UserProfile, advertisement: Advertisement) async {
        do {
            var newAdvertisement = advertisement
            newAdvertisement.releaseDate = Temporal.DateTime.now()
            newAdvertisement.setUserProfile(userProfile)
            let result = try await Amplify.API.mutate(request: .create(newAdvertisement, authMode: .amazonCognitoUserPools))
            switch result {
            case .success(let advertisement):
                print("Successfully created advertisement: \(advertisement)")
            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
            }
        } catch let error as APIError {
            print("Failed to create advertisement: ", error)
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func updateAdvertisement(userProfile: UserProfile, advertisement: Advertisement) async {
        do {
            var existingAdvertisement = advertisement
            existingAdvertisement.setUserProfile(userProfile)
            let result = try await Amplify.API.mutate(request: .update(existingAdvertisement, authMode: .amazonCognitoUserPools))
            switch result {
            case .success(let advertisement):
                print("Successfully updated advertisement: \(advertisement)")
            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
            }
        } catch let error as APIError {
            print("Failed to updated advertisement: ", error)
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func createPet(userProfile: UserProfile, pet: Pet) async {
        do {
            var newPet = pet
            newPet.setUserProfile(userProfile)
            let result = try await Amplify.API.mutate(request: .create(newPet, authMode: .amazonCognitoUserPools))
            switch result {
            case .success(let pet):
                print("Successfully created pet: \(pet)")
            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
            }
        } catch let error as APIError {
            print("Failed to create pet: ", error)
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func updatePet(userProfile: UserProfile, pet: Pet) async {
        do {
            var existingPet = pet
            existingPet.setUserProfile(userProfile)
            let result = try await Amplify.API.mutate(request: .update(existingPet, authMode: .amazonCognitoUserPools))
            switch result {
            case .success(let pet):
                print("Successfully updated pet: \(pet)")
            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
            }
        } catch let error as APIError {
            print("Failed to updated pet: ", error)
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func createTag(userProfile: UserProfile, tag: Tag) async {
        do {
            let newTag = UserProfileTag(userProfile: userProfile, tag: tag)
            let result = try await Amplify.API.mutate(request: .create(newTag, authMode: .amazonCognitoUserPools))
            switch result {
            case .success(let tag):
                print("Successfully created tag: \(tag)")
            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
            }
        } catch let error as APIError {
            print("Failed to create tag: ", error)
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func updateTag(userProfileTag: UserProfileTag, tag: Tag) async {
        do {
            var existingUserProfileTag = userProfileTag
            existingUserProfileTag.setTag(tag)
            let result = try await Amplify.API.mutate(request: .update(existingUserProfileTag, authMode: .amazonCognitoUserPools))
            switch result {
            case .success(let tag):
                print("Successfully updated tag: \(tag)")
            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
            }
        } catch let error as APIError {
            print("Failed to updated tag: ", error)
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func deleteTag(userProfileTag: UserProfileTag) async {
        do {
            let result = try await Amplify.API.mutate(request: .delete(userProfileTag, authMode: .amazonCognitoUserPools))
            switch result {
            case .success(let tag):
                print("Successfully deleted tag: \(tag)")
            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
            }
        } catch let error as APIError {
            print("Failed to deleted tag: ", error)
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func createWatchListItem(userProfile: UserProfile, advertisement: Advertisement) async {
        do {
            let newWatchListItem = WatchList(userProfile: userProfile, advertisement: advertisement)
            let result = try await Amplify.API.mutate(request: .create(newWatchListItem, authMode: .amazonCognitoUserPools))
            switch result {
            case .success(let watchListItem):
                print("Successfully created watch list item: \(watchListItem)")
            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
            }
        } catch let error as APIError {
            print("Failed to create watch list item: ", error)
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func deleteWatchListItem(watchList: WatchList) async {
        do {
            let result = try await Amplify.API.mutate(request: .delete(watchList, authMode: .amazonCognitoUserPools))
            switch result {
            case .success(let watchListItem):
                print("Successfully deleted watch list item: \(watchListItem)")
            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
            }
        } catch let error as APIError {
            print("Failed to delete watch list item: ", error)
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func createFollows(follower: UserProfile, followed: UserProfile) async {
        do {
            let newUserProfileFollower = UserProfileFollower(follower: follower, followed: followed)
            let result = try await Amplify.API.mutate(request: .create(newUserProfileFollower, authMode: .amazonCognitoUserPools))
            switch result {
            case .success(let userProfileFollower):
                print("Successfully created user profile follower: \(userProfileFollower)")
            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
            }
        } catch let error as APIError {
            print("Failed to create user profile follower: ", error)
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func deleteFollows(userProfileFollower: UserProfileFollower) async {
        do {
            let result = try await Amplify.API.mutate(request: .delete(userProfileFollower, authMode: .amazonCognitoUserPools))
            switch result {
            case .success(let userProfileFollower):
                print("Successfully deleted user profile follower: \(userProfileFollower)")
            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
            }
        } catch let error as APIError {
            print("Failed to delete user profile follower: ", error)
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func fetchPetTypes() async -> [PetType] {
        var petTypes: [PetType] = []
        let request = GraphQLRequest<PetType>.list(PetType.self, limit: 1000, authMode: .amazonCognitoUserPools)
        
        do {
            let result = try await Amplify.API.query(request: request)
            switch result {
            case .success(let petTypesResult):
                print("Successfully retrieved pet types: \(petTypesResult)")
                petTypes.append(contentsOf: petTypesResult)
            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
            }
        } catch let error as APIError {
            print("Failed to query pet type: ", error)
        } catch {
            print("Unexpected error: \(error)")
        }
        
        return petTypes
    }
    
    func fetchTags() async -> [Tag] {
        var tags: [Tag] = []
        let request = GraphQLRequest<PetType>.list(Tag.self, limit: 1000, authMode: .amazonCognitoUserPools)
        
        do {
            let result = try await Amplify.API.query(request: request)
            switch result {
            case .success(let tagsResult):
                print("Successfully retrieved tags: \(tagsResult)")
                tags.append(contentsOf: tagsResult)
            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
            }
        } catch let error as APIError {
            print("Failed to query tags: ", error)
        } catch {
            print("Unexpected error: \(error)")
        }
        
        return tags
    }
    
    func fetchWatchListItem(userProfile: UserProfile, advertisement: Advertisement) async -> WatchList? {
        var watchList: [WatchList] = []
        let watchListKeys = WatchList.keys
        let predicate = watchListKeys.userProfile.eq(userProfile.id) && watchListKeys.advertisement.eq(advertisement.id)
        let request = GraphQLRequest<WatchList>.list(WatchList.self, where: predicate, limit: 1000, authMode: .amazonCognitoUserPools)
        
        do {
            let result = try await Amplify.API.query(request: request)
            switch result {
            case .success(let watchListResult):
                print("Successfully retrieved watch list items: \(watchListResult)")
                watchList.append(contentsOf: watchListResult)
            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
            }
        } catch let error as APIError {
            print("Failed to query watch list items: ", error)
        } catch {
            print("Unexpected error: \(error)")
        }
        
        return watchList.first
    }
    
    func fetchFollow(follower: UserProfile, followed: UserProfile) async -> UserProfileFollower? {
        var userProfileFollower: [UserProfileFollower] = []
        let userProfileFollowerKeys = UserProfileFollower.keys
        let predicate = userProfileFollowerKeys.follower.eq(follower.id) && userProfileFollowerKeys.followed.eq(followed.id)
        let request = GraphQLRequest<WatchList>.list(UserProfileFollower.self, where: predicate, limit: 1000, authMode: .amazonCognitoUserPools)
        
        do {
            let result = try await Amplify.API.query(request: request)
            switch result {
            case .success(let userProfileFollowerResult):
                print("Successfully retrieved user profile follower items: \(userProfileFollowerResult)")
                userProfileFollower.append(contentsOf: userProfileFollowerResult)
            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
            }
        } catch let error as APIError {
            print("Failed to query user profile follower items: ", error)
        } catch {
            print("Unexpected error: \(error)")
        }
        
        return userProfileFollower.first
    }
    
    func fetchChats(userProfile: UserProfile) async -> [Chat] {
        var chats: [Chat] = []
        let chatKeys = Chat.keys
        let predicate = chatKeys.userProfile.eq(userProfile.id) || chatKeys.recipient.eq(userProfile.id)
        let request = GraphQLRequest<WatchList>.list(Chat.self, where: predicate, limit: 1000, authMode: .amazonCognitoUserPools)
        
        do {
            let result = try await Amplify.API.query(request: request)
            switch result {
            case .success(let chatsResult):
                print("Successfully retrieved chats: \(chatsResult)")
                chats.append(contentsOf: chatsResult)
            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
            }
        } catch let error as APIError {
            print("Failed to query chats: ", error)
        } catch {
            print("Unexpected error: \(error)")
        }
        
        return chats
    }
    
    func fetchChatsByAdvertisement(advertisement: Advertisement) async -> [Chat] {
        var chats: [Chat] = []
        let chatKeys = Chat.keys
        let predicate = chatKeys.advertisement.eq(advertisement.id)
        let request = GraphQLRequest<WatchList>.list(Chat.self, where: predicate, limit: 1000, authMode: .amazonCognitoUserPools)
        
        do {
            let result = try await Amplify.API.query(request: request)
            switch result {
            case .success(let chatsResult):
                print("Successfully retrieved chats: \(chatsResult)")
                chats.append(contentsOf: chatsResult)
            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
            }
        } catch let error as APIError {
            print("Failed to query chats: ", error)
        } catch {
            print("Unexpected error: \(error)")
        }
        
        return chats
    }
    
    func fetchPets(userProfile: UserProfile) async {
        let petKeys = Pet.keys
        let predicate = petKeys.userProfile.eq(userProfile.id)
        let request = GraphQLRequest<WatchList>.list(Pet.self, where: predicate, limit: 1000, authMode: .amazonCognitoUserPools)
        
        do {
            let result = try await Amplify.API.query(request: request)
            switch result {
            case .success(let petsResult):
                print("Successfully retrieved pets: \(petsResult)")
                self.userProfile?.pets = petsResult
            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
            }
        } catch let error as APIError {
            print("Failed to query pets: ", error)
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func fetchAdvertisements(userProfile: UserProfile) async {
        let advertisementKeys = Advertisement.keys
        let predicate = advertisementKeys.userProfile.eq(userProfile.id)
        let request = GraphQLRequest<WatchList>.list(Advertisement.self, where: predicate, limit: 1000, authMode: .amazonCognitoUserPools)
        
        do {
            let result = try await Amplify.API.query(request: request)
            switch result {
            case .success(let advertisementResult):
                print("Successfully retrieved ads: \(advertisementResult)")
                self.userProfile?.advertisements = advertisementResult
            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
            }
        } catch let error as APIError {
            print("Failed to query ads: ", error)
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func fetchUserProfileTags(userProfile: UserProfile) async {
        let userProfileTagKeys = UserProfileTag.keys
        let predicate = userProfileTagKeys.userProfile.eq(userProfile.id)
        let request = GraphQLRequest<WatchList>.list(UserProfileTag.self, where: predicate, limit: 1000, authMode: .amazonCognitoUserPools)
        
        do {
            let result = try await Amplify.API.query(request: request)
            switch result {
            case .success(let userProfileTagResult):
                print("Successfully retrieved user profile tags: \(userProfileTagResult)")
                self.userProfile?.tags = userProfileTagResult
            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
            }
        } catch let error as APIError {
            print("Failed to query user profile tags: ", error)
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    static let sampleData: [UserProfile] = [
        UserProfile(
            id: "11480ab1-4433-4129-b766-c07fda9652bd",
            description: "Hallo, ich bin die Anna und komme aus der Stadt Musterhausen. In meiner Freizeit gehe ich mit meinem Hund und meinem Pferd spazieren und streichel gerne meinen Kater.\n\nAktuell bin ich auf der Suche nach einem Hundesitter, Katzensitter und einer Reitbeteiligung.",
            activeSince: Temporal.Date.now(),
            profileImage: false,
            location: "Musterhausen",
            author: "anna96",
            tags:
                [
                    UserProfileTag(id: UUID().uuidString, tag: Tag(id: UUID().uuidString, description: "Nichtraucher-Haushalt")),
                    UserProfileTag(id: UUID().uuidString, tag: Tag(id: UUID().uuidString, description: "Erfahrung mit Hunden")),
                    UserProfileTag(id: UUID().uuidString, tag: Tag(id: UUID().uuidString, description: "Erfahrung mit Pferden"))
                ],
            pets:
                [
                    Pet(id: UUID().uuidString, description: "Momo ist ein super lieber Tuxedo-Kater, der Gesellschaft liebt und super herumgetragen werden kann", name: "Momo", age: 4, petImage: false, petType: PetType(id: UUID().uuidString, description: "Katze"), petBreed: PetBreed(id: UUID().uuidString, description: "Europäisch Kurzhaar Mix")),
                    Pet(id: UUID().uuidString, description: "Nemo ist ein kleiner, süßer Choco-Chihuahua, der es liebt zu kuscheln.", name: "Nemo", age: 5, petImage: false, petType: PetType(id: UUID().uuidString, description: "Hund"), petBreed: PetBreed(id: UUID().uuidString, description: "Chihuahua")),
                    Pet(id: UUID().uuidString, description: "Eddy ist mein Lieblingspony.", name: "Eddy", age: 10, petImage: false, petType: PetType(id: UUID().uuidString, description: "Pferd"), petBreed: PetBreed(id: UUID().uuidString, description: "Mini-Shetty")),
                ],
            watchLists:
                [
                    WatchList(id: UUID().uuidString, userProfile: UserProfile(id: "11480ab1-4433-4129-b766-c07fda9652bd"), advertisement: Advertisement(title: "Neue Anzeige 2", releaseDate: Temporal.DateTime.now(), visitor: 15, description: "Das ist eine Anzeige"))
                ],
            advertisements:
                [
                    Advertisement(id: "9FCF5DD5-1D65-4A82-BE76-42CB438607A0", advertisementId: nil, title: "Katzen-Sitter für Kater gesucht", releaseDate: Temporal.DateTime.now(), visitor: 15, description: "Die Beschreibung ist eine Aufsatzart. Sie informiert sachlich über ein Objekt, dass betrachtet wird und beschrieben werden soll. Die verwendete Sprache sollte an die Zielgruppe angepasst sein.\n\nZiel einer Beschreibung ist es einen gegebenen Gegenstand oder Situation dem Leser blalba genauestens zu vermitteln.\nSprachliche Stilmittel und die chronologisch sowie sinnvolle Beschreibung ist hier besonders wichtig.", advertisementImages: ["TestImage2","TestImage1"], tags: nil, watchLists: nil, userProfile: nil, chats: nil),
                    Advertisement(id: "9FCF5DD5-1D65-4A82-BE76-42CB438607A0", title: "Neue Anzeige 1", releaseDate: Temporal.DateTime.now(), visitor: 15, description: "Das ist eine Anzeige"),
                    Advertisement(id: "9FCF5DD5-1D65-4A82-BE76-42CB438607A0", title: "Neue Anzeige 2", releaseDate: Temporal.DateTime.now(), visitor: 15, description: "Das ist eine andere Anzeige")
                ],
            chats: [
                Chat(id: UUID().uuidString, message: "Hey, ich habe gesehen, dass du einen Hundesitter suchst. Bisher konnte ich nur wenig Erfahrung sammeln, aber ich könnte mir zutrauen auf deinen Chihuahua aufzupassen.", author: "markus99", recipient: "anna96", advertisement: Advertisement(id: "9FCF5DD5-1D65-4A82-BE76-42CB438607A0", title: "Neue Anzeige 1", releaseDate: Temporal.DateTime.now(), visitor: 15, description: "Das ist eine Anzeige"), updatedAt: Temporal.DateTime.now()),
                Chat(id: UUID().uuidString, message: "Hey, das klingt super! Wir können gerne ein Treffen ausmachen. Wann hättest du Zeit?", author: "anna96", recipient: "markus99", advertisement: Advertisement(id: "9FCF5DD5-1D65-4A82-BE76-42CB438607A0", title: "Neue Anzeige 1", releaseDate: Temporal.DateTime.now(), visitor: 15, description: "Das ist eine Anzeige"), updatedAt: Temporal.DateTime.now()),
                Chat(id: UUID().uuidString, message: "Bei mir würde morgen, um 17:00 Uhr passen. Passt das bei dir?", author: "markus99", recipient: "anna96", advertisement: Advertisement(id: "9FCF5DD5-1D65-4A82-BE76-42CB438607A0", title: "Neue Anzeige 1", releaseDate: Temporal.DateTime.now(), visitor: 15, description: "Das ist eine Anzeige"), updatedAt: Temporal.DateTime.now()),
                Chat(id: UUID().uuidString, message: "Ja, das passt! Bis morgen!", author: "anna96", recipient: "markus99", advertisement: Advertisement(id: "9FCF5DD5-1D65-4A82-BE76-42CB438607A0", title: "Neue Anzeige 1", releaseDate: Temporal.DateTime.now(), visitor: 15, description: "Das ist eine Anzeige"), updatedAt: Temporal.DateTime.now())
            ],
            follows: [
                UserProfileFollower(id: UUID().uuidString, follower: UserProfile(id: "11480ab1-4433-4129-b766-c07fda9652bd", location: "Musterhausen", author: "anna96"), followed: UserProfile(id: "f76c13f3-b814-49b4-b30b-096d65977cd9", location: "Entenhausen", author: "markus99"))
            ]
        ),
        UserProfile(
            id: "f76c13f3-b814-49b4-b30b-096d65977cd9",
            description: "Hallo, ich bin Markus und komme aus der Stadt Entenhausen. Aktuell bin ich Vollzeit beschäftigt, sodass ich mich nicht traue einen eigenen Hund zu adoptieren.\n\nIch möchte gerne Erfahrung mit Hunden sammeln.",
            activeSince: Temporal.Date.now(),
            profileImage: false,
            location: "Entenhausen",
            author: "markus99",
            tags:
                [
                    UserProfileTag(id: UUID().uuidString, tag: Tag(id: UUID().uuidString, description: "Nichtraucher-Haushalt")),
                    UserProfileTag(id: UUID().uuidString, tag: Tag(id: UUID().uuidString, description: "Keine Erfahrung"))
                ],
            watchLists:
                [
                    WatchList(id: UUID().uuidString, userProfile: UserProfile(id: "f76c13f3-b814-49b4-b30b-096d65977cd9"), advertisement: Advertisement(title: "Neue Anzeige 1", releaseDate: Temporal.DateTime.now(), visitor: 15, description: "Das ist eine Anzeige"))
                ],
            advertisements:
                [
                    Advertisement(id: UUID().uuidString, title: "Neue Anzeige 2", releaseDate: Temporal.DateTime.now(), visitor: 15, description: "Das ist eine Anzeige")
                ],
            chats: [
                Chat(id: UUID().uuidString, message: "Hey, ich habe gesehen, dass du einen Hundesitter suchst. Bisher konnte ich nur wenig Erfahrung sammeln, aber ich könnte mir zutrauen auf deinen Chihuahua aufzupassen.", author: "markus99", recipient: "anna96", advertisement: Advertisement(title: "Neue Anzeige 1", releaseDate: Temporal.DateTime.now(), visitor: 15, description: "Das ist eine Anzeige"), updatedAt: Temporal.DateTime.now()),
                Chat(id: UUID().uuidString, message: "Hey, das klingt super! Wir können gerne ein Treffen ausmachen. Wann hättest du Zeit?", author: "anna96", recipient: "markus99", advertisement: Advertisement(id: "9FCF5DD5-1D65-4A82-BE76-42CB438607A0", title: "Neue Anzeige 1", releaseDate: Temporal.DateTime.now(), visitor: 15, description: "Das ist eine Anzeige"), updatedAt: Temporal.DateTime.now()),
                Chat(id: UUID().uuidString, message: "Bei mir würde morgen, um 17:00 Uhr passen. Passt das bei dir?", author: "markus99", recipient: "anna96", advertisement: Advertisement(id: "9FCF5DD5-1D65-4A82-BE76-42CB438607A0", title: "Neue Anzeige 1", releaseDate: Temporal.DateTime.now(), visitor: 15, description: "Das ist eine Anzeige"), updatedAt: Temporal.DateTime.now()),
                Chat(id: UUID().uuidString, message: "Ja, das passt! Bis morgen!", author: "anna96", recipient: "markus99", advertisement: Advertisement(id: "9FCF5DD5-1D65-4A82-BE76-42CB438607A0", title: "Neue Anzeige 1", releaseDate: Temporal.DateTime.now(), visitor: 15, description: "Das ist eine Anzeige"), updatedAt: Temporal.DateTime.now())
            ]
        )
    ]
}
