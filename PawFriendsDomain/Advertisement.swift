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
  public var author: String?
  public var tags: List<AdvertisementTag>?
  public var watchLists: List<WatchList>?
  internal var _userProfile: LazyReference<UserProfile>
  public var userProfile: UserProfile?   {
      get async throws { 
        try await _userProfile.get()
      } 
    }
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
      author: String? = nil,
      tags: List<AdvertisementTag>? = [],
      watchLists: List<WatchList>? = [],
      userProfile: UserProfile? = nil,
      chats: List<Chat>? = []) {
    self.init(id: id,
      advertisementId: advertisementId,
      title: title,
      releaseDate: releaseDate,
      visitor: visitor,
      description: description,
      advertisementImages: advertisementImages,
      author: author,
      tags: tags,
      watchLists: watchLists,
      userProfile: userProfile,
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
      author: String? = nil,
      tags: List<AdvertisementTag>? = [],
      watchLists: List<WatchList>? = [],
      userProfile: UserProfile? = nil,
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
      self.author = author
      self.tags = tags
      self.watchLists = watchLists
      self._userProfile = LazyReference(userProfile)
      self.chats = chats
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
  public mutating func setUserProfile(_ userProfile: UserProfile? = nil) {
    self._userProfile = LazyReference(userProfile)
  }
  public init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      id = try values.decode(String.self, forKey: .id)
      advertisementId = try? values.decode(String?.self, forKey: .advertisementId)
      title = try? values.decode(String?.self, forKey: .title)
      releaseDate = try? values.decode(Temporal.DateTime?.self, forKey: .releaseDate)
      visitor = try? values.decode(Int?.self, forKey: .visitor)
      description = try? values.decode(String?.self, forKey: .description)
      advertisementImages = try? values.decode([String].self, forKey: .advertisementImages)
      author = try? values.decode(String?.self, forKey: .author)
      tags = try values.decodeIfPresent(List<AdvertisementTag>?.self, forKey: .tags) ?? .init()
      watchLists = try values.decodeIfPresent(List<WatchList>?.self, forKey: .watchLists) ?? .init()
      _userProfile = try values.decodeIfPresent(LazyReference<UserProfile>.self, forKey: .userProfile) ?? LazyReference(identifiers: nil)
      chats = try values.decodeIfPresent(List<Chat>?.self, forKey: .chats) ?? .init()
      createdAt = try? values.decode(Temporal.DateTime?.self, forKey: .createdAt)
      updatedAt = try? values.decode(Temporal.DateTime?.self, forKey: .updatedAt)
  }
  public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(id, forKey: .id)
      try container.encode(advertisementId, forKey: .advertisementId)
      try container.encode(title, forKey: .title)
      try container.encode(releaseDate, forKey: .releaseDate)
      try container.encode(visitor, forKey: .visitor)
      try container.encode(description, forKey: .description)
      try container.encode(advertisementImages, forKey: .advertisementImages)
      try container.encode(author, forKey: .author)
      try container.encode(tags, forKey: .tags)
      try container.encode(watchLists, forKey: .watchLists)
      try container.encode(_userProfile, forKey: .userProfile)
      try container.encode(chats, forKey: .chats)
      try container.encode(createdAt, forKey: .createdAt)
      try container.encode(updatedAt, forKey: .updatedAt)
  }
}