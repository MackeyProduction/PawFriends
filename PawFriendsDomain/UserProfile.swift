// swiftlint:disable all
import Amplify
import Foundation

public struct UserProfile: Model {
  public let id: String
  public var userProfileId: String?
  public var description: String?
  public var activeSince: Temporal.Date?
  public var profileImage: Bool?
  public var location: String?
  public var author: String?
  public var tags: List<UserProfileTag>?
  public var pets: List<UserProfilePet>?
  public var watchLists: List<WatchList>?
  public var advertisements: List<UserProfileAdvertisement>?
  public var chats: List<Chat>?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      userProfileId: String? = nil,
      description: String? = nil,
      activeSince: Temporal.Date? = nil,
      profileImage: Bool? = nil,
      location: String? = nil,
      author: String? = nil,
      tags: List<UserProfileTag>? = [],
      pets: List<UserProfilePet>? = [],
      watchLists: List<WatchList>? = [],
      advertisements: List<UserProfileAdvertisement>? = [],
      chats: List<Chat>? = []) {
    self.init(id: id,
      userProfileId: userProfileId,
      description: description,
      activeSince: activeSince,
      profileImage: profileImage,
      location: location,
      author: author,
      tags: tags,
      pets: pets,
      watchLists: watchLists,
      advertisements: advertisements,
      chats: chats,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      userProfileId: String? = nil,
      description: String? = nil,
      activeSince: Temporal.Date? = nil,
      profileImage: Bool? = nil,
      location: String? = nil,
      author: String? = nil,
      tags: List<UserProfileTag>? = [],
      pets: List<UserProfilePet>? = [],
      watchLists: List<WatchList>? = [],
      advertisements: List<UserProfileAdvertisement>? = [],
      chats: List<Chat>? = [],
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.userProfileId = userProfileId
      self.description = description
      self.activeSince = activeSince
      self.profileImage = profileImage
      self.location = location
      self.author = author
      self.tags = tags
      self.pets = pets
      self.watchLists = watchLists
      self.advertisements = advertisements
      self.chats = chats
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}