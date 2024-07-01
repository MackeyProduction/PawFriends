// swiftlint:disable all
import Amplify
import Foundation

public struct UserProfileFollower: Model {
  public let id: String
  public var author: String?
  internal var _follower: LazyReference<UserProfile>
  public var follower: UserProfile?   {
      get async throws { 
        try await _follower.get()
      } 
    }
  internal var _followed: LazyReference<UserProfile>
  public var followed: UserProfile?   {
      get async throws { 
        try await _followed.get()
      } 
    }
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      author: String? = nil,
      follower: UserProfile? = nil,
      followed: UserProfile? = nil) {
    self.init(id: id,
      author: author,
      follower: follower,
      followed: followed,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      author: String? = nil,
      follower: UserProfile? = nil,
      followed: UserProfile? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.author = author
      self._follower = LazyReference(follower)
      self._followed = LazyReference(followed)
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
  public mutating func setFollower(_ follower: UserProfile? = nil) {
    self._follower = LazyReference(follower)
  }
  public mutating func setFollowed(_ followed: UserProfile? = nil) {
    self._followed = LazyReference(followed)
  }
  public init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      id = try values.decode(String.self, forKey: .id)
      author = try? values.decode(String?.self, forKey: .author)
      _follower = try values.decodeIfPresent(LazyReference<UserProfile>.self, forKey: .follower) ?? LazyReference(identifiers: nil)
      _followed = try values.decodeIfPresent(LazyReference<UserProfile>.self, forKey: .followed) ?? LazyReference(identifiers: nil)
      createdAt = try? values.decode(Temporal.DateTime?.self, forKey: .createdAt)
      updatedAt = try? values.decode(Temporal.DateTime?.self, forKey: .updatedAt)
  }
  public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(id, forKey: .id)
      try container.encode(author, forKey: .author)
      try container.encode(_follower, forKey: .follower)
      try container.encode(_followed, forKey: .followed)
      try container.encode(createdAt, forKey: .createdAt)
      try container.encode(updatedAt, forKey: .updatedAt)
  }
}