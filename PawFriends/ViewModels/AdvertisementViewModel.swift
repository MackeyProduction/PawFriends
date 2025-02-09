//
//  AdvertisementViewModel.swift
//  PawFriends
//
//  Created by Til Anheier on 18.06.24.
//

import Foundation
import Amplify

@MainActor
class AdvertisementViewModel: ObservableObject {
    @Published var advertisements: [Advertisement] = []
    @Published var advertisement: Advertisement? = nil
    
    init(advertisements: [Advertisement] = []) {
        self.advertisements = advertisements
    }
    
    func listAdvertisements() async {
        let request = GraphQLRequest<Advertisement>.list(Advertisement.self)
        do {
            let result = try await Amplify.API.query(request: request)
            switch result {
            case .success(let advertisements):
                print("Successfully retrieved list of advertisements: \(advertisements)")
                self.advertisements = advertisements.elements
            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
            }
        } catch let error as APIError {
            print("Failed to query list of advertisements: ", error)
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func getAdvertisement(_ id : UUID) {
        let request = GraphQLRequest<Advertisement>.get(Advertisement.self, byId: id.uuidString)
        Task {
            do {
                let result = try await Amplify.API.query(request: request)
                switch result {
                case .success(let advertisement):
                    guard let advertisement = advertisement else {
                        print("Could not find advertisement")
                        return
                    }
                    print("Successfully retrieved advertisement: \(advertisement)")
                    self.advertisement = advertisement
                case .failure(let error):
                    print("Got failed result with \(error.errorDescription)")
                }
            } catch let error as APIError {
                print("Failed to query advertisement: ", error)
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
    
    func createTag(advertisement: Advertisement, tag: Tag) async {
        do {
            let newTag = AdvertisementTag(advertisement: advertisement, tag: tag)
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
    
    func updateTag(advertisementTag: AdvertisementTag, tag: Tag) async {
        do {
            var existingAdvertisementTag = advertisementTag
            existingAdvertisementTag.setTag(tag)
            let result = try await Amplify.API.mutate(request: .update(existingAdvertisementTag, authMode: .amazonCognitoUserPools))
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
    
    func deleteTag(advertisementTag: AdvertisementTag) async {
        do {
            let result = try await Amplify.API.mutate(request: .delete(advertisementTag, authMode: .amazonCognitoUserPools))
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
    
    static let sampleData: [Advertisement] = [
        Advertisement(id: UUID().uuidString, advertisementId: nil, title: "Katzen-Sitter für Kater gesucht", releaseDate: Temporal.DateTime.now(), visitor: 15, description: "Die Beschreibung ist eine Aufsatzart. Sie informiert sachlich über ein Objekt, dass betrachtet wird und beschrieben werden soll. Die verwendete Sprache sollte an die Zielgruppe angepasst sein.\n\nZiel einer Beschreibung ist es einen gegebenen Gegenstand oder Situation dem Leser blalba genauestens zu vermitteln.\nSprachliche Stilmittel und die chronologisch sowie sinnvolle Beschreibung ist hier besonders wichtig.", advertisementImages: ["TestImage2","TestImage1"], tags: nil, watchLists: nil, userProfile: nil, chats: nil),
        Advertisement(id: UUID().uuidString, advertisementId: nil, title: "Neue Anzeige 2", releaseDate: Temporal.DateTime.now(), visitor: 15, description: "Das ist eine Anzeige", advertisementImages: [], tags: nil, watchLists: nil, userProfile: nil, chats: nil)
    ]
}
