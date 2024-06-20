// swiftlint:disable all
import Amplify
import Foundation

public struct Tag: Model {
  public let id: String
  public var tagId: String?
  public var description: String?
  public var userProfiles: List<UserProfileTag>?
  public var advertisements: List<AdvertisementTag>?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      tagId: String? = nil,
      description: String? = nil,
      userProfiles: List<UserProfileTag>? = [],
      advertisements: List<AdvertisementTag>? = []) {
    self.init(id: id,
      tagId: tagId,
      description: description,
      userProfiles: userProfiles,
      advertisements: advertisements,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      tagId: String? = nil,
      description: String? = nil,
      userProfiles: List<UserProfileTag>? = [],
      advertisements: List<AdvertisementTag>? = [],
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.tagId = tagId
      self.description = description
      self.userProfiles = userProfiles
      self.advertisements = advertisements
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}