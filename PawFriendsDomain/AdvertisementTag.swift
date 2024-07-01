// swiftlint:disable all
import Amplify
import Foundation

public struct AdvertisementTag: Model {
  public let id: String
  public var author: String?
  internal var _advertisement: LazyReference<Advertisement>
  public var advertisement: Advertisement?   {
      get async throws { 
        try await _advertisement.get()
      } 
    }
  internal var _tag: LazyReference<Tag>
  public var tag: Tag?   {
      get async throws { 
        try await _tag.get()
      } 
    }
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      author: String? = nil,
      advertisement: Advertisement? = nil,
      tag: Tag? = nil) {
    self.init(id: id,
      author: author,
      advertisement: advertisement,
      tag: tag,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      author: String? = nil,
      advertisement: Advertisement? = nil,
      tag: Tag? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.author = author
      self._advertisement = LazyReference(advertisement)
      self._tag = LazyReference(tag)
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
  public mutating func setAdvertisement(_ advertisement: Advertisement? = nil) {
    self._advertisement = LazyReference(advertisement)
  }
  public mutating func setTag(_ tag: Tag? = nil) {
    self._tag = LazyReference(tag)
  }
  public init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      id = try values.decode(String.self, forKey: .id)
      author = try? values.decode(String?.self, forKey: .author)
      _advertisement = try values.decodeIfPresent(LazyReference<Advertisement>.self, forKey: .advertisement) ?? LazyReference(identifiers: nil)
      _tag = try values.decodeIfPresent(LazyReference<Tag>.self, forKey: .tag) ?? LazyReference(identifiers: nil)
      createdAt = try? values.decode(Temporal.DateTime?.self, forKey: .createdAt)
      updatedAt = try? values.decode(Temporal.DateTime?.self, forKey: .updatedAt)
  }
  public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(id, forKey: .id)
      try container.encode(author, forKey: .author)
      try container.encode(_advertisement, forKey: .advertisement)
      try container.encode(_tag, forKey: .tag)
      try container.encode(createdAt, forKey: .createdAt)
      try container.encode(updatedAt, forKey: .updatedAt)
  }
}