// swiftlint:disable all
import Amplify
import Foundation

public struct Advertisement: Model {
  public let id: String
  public var advertisementId: String?
  public var title: String?
  public var releaseDate: Temporal.DateTime?
  public var visitor: Int?
  public var description: String?
  public var advertisementImages: [String?]?
  public var tags: List<AdvertisementTag>?
  public var watchLists: List<WatchList>?
  public var userProfiles: List<UserProfileAdvertisement>?
  public var chats: List<Chat>?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      advertisementId: String? = nil,
      title: String? = nil,
      releaseDate: Temporal.DateTime? = nil,
      visitor: Int? = nil,
      description: String? = nil,
      advertisementImages: [String?]? = nil,
      tags: List<AdvertisementTag>? = [],
      watchLists: List<WatchList>? = [],
      userProfiles: List<UserProfileAdvertisement>? = [],
      chats: List<Chat>? = []) {
    self.init(id: id,
      advertisementId: advertisementId,
      title: title,
      releaseDate: releaseDate,
      visitor: visitor,
      description: description,
      advertisementImages: advertisementImages,
      tags: tags,
      watchLists: watchLists,
      userProfiles: userProfiles,
      chats: chats,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      advertisementId: String? = nil,
      title: String? = nil,
      releaseDate: Temporal.DateTime? = nil,
      visitor: Int? = nil,
      description: String? = nil,
      advertisementImages: [String?]? = nil,
      tags: List<AdvertisementTag>? = [],
      watchLists: List<WatchList>? = [],
      userProfiles: List<UserProfileAdvertisement>? = [],
      chats: List<Chat>? = [],
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.advertisementId = advertisementId
      self.title = title
      self.releaseDate = releaseDate
      self.visitor = visitor
      self.description = description
      self.advertisementImages = advertisementImages
      self.tags = tags
      self.watchLists = watchLists
      self.userProfiles = userProfiles
      self.chats = chats
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}