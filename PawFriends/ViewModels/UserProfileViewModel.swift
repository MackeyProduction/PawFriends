//
//  UserProfileViewModel.swift
//  PawFriends
//
//  Created by Til Anheier on 22.06.24.
//

import Foundation
import Amplify

@MainActor
class UserProfileViewModel: ObservableObject {
    @Published var userProfile: UserProfile? = nil
    
    init(userProfile: UserProfile? = nil) {
        self.userProfile = UserProfileViewModel.sampleData[0]
    }
    
    func getProfile(id: UUID) {
        let request = GraphQLRequest<UserProfile>.get(UserProfile.self, byId: id.uuidString)
        Task {
            do {
                let result = try await Amplify.API.query(request: request)
                switch result {
                case .success(let userProfile):
                    guard let userProfile = userProfile else {
                        print("Could not find user profile")
                        return
                    }
                    print("Successfully retrieved user profile: \(userProfile)")
                    self.userProfile = userProfile
                case .failure(let error):
                    print("Got failed result with \(error.errorDescription)")
                }
            } catch let error as APIError {
                print("Failed to query user profile: ", error)
            } catch {
                print("Unexpected error: \(error)")
            }
        }
    }
    
    func createProfile(userProfile: UserProfile) {
        Task {
            do {
                let result = try await Amplify.API.mutate(request: .create(userProfile))
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
    
    func createChat(chat: Chat) {
        Task {
            do {
                let result = try await Amplify.API.mutate(request: .create(chat))
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
    
    func createAdvertisement(advertisement: Advertisement) {
        Task {
            do {
                let result = try await Amplify.API.mutate(request: .create(advertisement))
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
    }
    
    func updateAdvertisement(advertisement: Advertisement) {
        Task {
            do {
                let result = try await Amplify.API.mutate(request: .update(advertisement))
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
    }
    
    func createPet(pet: Pet) {
        Task {
            do {
                let result = try await Amplify.API.mutate(request: .create(pet))
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
    }
    
    func updatePet(pet: Pet) {
        Task {
            do {
                let result = try await Amplify.API.mutate(request: .update(pet))
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
    }
    
    static let sampleData: [UserProfile] = [
        UserProfile(
            id: UUID().uuidString,
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
                    Pet(id: UUID().uuidString, description: "Nemo ist ein kleiner, süßer Choco-Chihuahua, der es liebt zu kuscheln.", name: "Nemo", age: 5, petImage: false, petType: PetType(id: UUID().uuidString, description: "Hund"), petBreed: PetBreed(id: UUID().uuidString, description: "Chihuahua")),
                    Pet(id: UUID().uuidString, description: "Eddy ist mein Lieblingspony.", name: "Eddy", age: 10, petImage: false, petType: PetType(id: UUID().uuidString, description: "Pferd"), petBreed: PetBreed(id: UUID().uuidString, description: "Mini-Shetty")),
                    Pet(id: UUID().uuidString, description: "Momo ist ein super lieber Tuxedo-Kater, der Gesellschaft liebt und super herumgetragen werden kann", name: "Momo", age: 4, petImage: false, petType: PetType(id: UUID().uuidString, description: "Katze"), petBreed: PetBreed(id: UUID().uuidString, description: "Europäisch Kurzhaar Mix")),
                ],
            watchLists:
                [
                    WatchList(id: UUID().uuidString, advertisement: Advertisement(title: "Neue Anzeige 2", releaseDate: Temporal.DateTime.now(), visitor: 15, description: "Das ist eine Anzeige"))
                ],
            advertisements:
                [
                    Advertisement(id: "9FCF5DD5-1D65-4A82-BE76-42CB438607A0", title: "Neue Anzeige 1", releaseDate: Temporal.DateTime.now(), visitor: 15, description: "Das ist eine Anzeige"),
                    Advertisement(id: "9FCF5DD5-1D65-4A82-BE76-42CB438607A0", title: "Neue Anzeige 2", releaseDate: Temporal.DateTime.now(), visitor: 15, description: "Das ist eine andere Anzeige")
                ],
            chats: [
                Chat(id: UUID().uuidString, message: "Hey, ich habe gesehen, dass du einen Hundesitter suchst. Bisher konnte ich nur wenig Erfahrung sammeln, aber ich könnte mir zutrauen auf deinen Chihuahua aufzupassen.", author: "markus99", recipient: "anna96", advertisement: Advertisement(id: "9FCF5DD5-1D65-4A82-BE76-42CB438607A0", title: "Neue Anzeige 1", releaseDate: Temporal.DateTime.now(), visitor: 15, description: "Das ist eine Anzeige"), updatedAt: Temporal.DateTime.now()),
                Chat(id: UUID().uuidString, message: "Hey, das klingt super! Wir können gerne ein Treffen ausmachen. Wann hättest du Zeit?", author: "anna96", recipient: "markus99", advertisement: Advertisement(id: "9FCF5DD5-1D65-4A82-BE76-42CB438607A0", title: "Neue Anzeige 1", releaseDate: Temporal.DateTime.now(), visitor: 15, description: "Das ist eine Anzeige"), updatedAt: Temporal.DateTime.now()),
                Chat(id: UUID().uuidString, message: "Bei mir würde morgen, um 17:00 Uhr passen. Passt das bei dir?", author: "markus99", recipient: "anna96", advertisement: Advertisement(id: "9FCF5DD5-1D65-4A82-BE76-42CB438607A0", title: "Neue Anzeige 1", releaseDate: Temporal.DateTime.now(), visitor: 15, description: "Das ist eine Anzeige"), updatedAt: Temporal.DateTime.now()),
                Chat(id: UUID().uuidString, message: "Ja, das passt! Bis morgen!", author: "anna96", recipient: "markus99", advertisement: Advertisement(id: "9FCF5DD5-1D65-4A82-BE76-42CB438607A0", title: "Neue Anzeige 1", releaseDate: Temporal.DateTime.now(), visitor: 15, description: "Das ist eine Anzeige"), updatedAt: Temporal.DateTime.now())
            ]
        ),
        UserProfile(
            id: UUID().uuidString,
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
                    WatchList(id: UUID().uuidString, advertisement: Advertisement(title: "Neue Anzeige 1", releaseDate: Temporal.DateTime.now(), visitor: 15, description: "Das ist eine Anzeige"))
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
