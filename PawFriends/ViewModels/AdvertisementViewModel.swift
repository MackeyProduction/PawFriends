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
    @Published var advertisement: Advertisement
    
    func listAdvertisements() {
        let request = GraphQLRequest<Advertisement>.list(Advertisement.self)
        Task {
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
}
