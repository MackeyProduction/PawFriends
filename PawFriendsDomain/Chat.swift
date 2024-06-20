// swiftlint:disable all
import Amplify
import Foundation

public struct Chat: Model {
  public let id: String
  public var message: String?
  public var author: String?
  public var recipient: String?
  internal var _userProfile: LazyReference<UserProfile>
  public var userProfile: UserProfile?   {
      get async throws { 
        try await _userProfile.get()
      } 
    }
  internal var _advertisement: LazyReference<Advertisement>
  public var advertisement: Advertisement?   {
      get async throws { 
        try await _advertisement.get()
      } 
    }
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      message: String? = nil,
      author: String? = nil,
      recipient: String? = nil,
      userProfile: UserProfile? = nil,
      advertisement: Advertisement? = nil) {
    self.init(id: id,
      message: message,
      author: author,
      recipient: recipient,
      userProfile: userProfile,
      advertisement: advertisement,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      message: String? = nil,
      author: String? = nil,
      recipient: String? = nil,
      userProfile: UserProfile? = nil,
      advertisement: Advertisement? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.message = message
      self.author = author
      self.recipient = recipient
      self._userProfile = LazyReference(userProfile)
      self._advertisement = LazyReference(advertisement)
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
  public mutating func setUserProfile(_ userProfile: UserProfile? = nil) {
    self._userProfile = LazyReference(userProfile)
  }
  public mutating func setAdvertisement(_ advertisement: Advertisement? = nil) {
    self._advertisement = LazyReference(advertisement)
  }
  public init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      id = try values.decode(String.self, forKey: .id)
      message = try? values.decode(String?.self, forKey: .message)
      author = try? values.decode(String?.self, forKey: .author)
      recipient = try? values.decode(String?.self, forKey: .recipient)
      _userProfile = try values.decodeIfPresent(LazyReference<UserProfile>.self, forKey: .userProfile) ?? LazyReference(identifiers: nil)
      _advertisement = try values.decodeIfPresent(LazyReference<Advertisement>.self, forKey: .advertisement) ?? LazyReference(identifiers: nil)
      createdAt = try? values.decode(Temporal.DateTime?.self, forKey: .createdAt)
      updatedAt = try? values.decode(Temporal.DateTime?.self, forKey: .updatedAt)
  }
  public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(id, forKey: .id)
      try container.encode(message, forKey: .message)
      try container.encode(author, forKey: .author)
      try container.encode(recipient, forKey: .recipient)
      try container.encode(_userProfile, forKey: .userProfile)
      try container.encode(_advertisement, forKey: .advertisement)
      try container.encode(createdAt, forKey: .createdAt)
      try container.encode(updatedAt, forKey: .updatedAt)
  }
}