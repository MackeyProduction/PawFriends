// swiftlint:disable all
import Amplify
import Foundation

public struct UserProfilePet: Model {
  public let id: String
  internal var _userProfile: LazyReference<UserProfile>
  public var userProfile: UserProfile?   {
      get async throws { 
        try await _userProfile.get()
      } 
    }
  internal var _pet: LazyReference<Pet>
  public var pet: Pet?   {
      get async throws { 
        try await _pet.get()
      } 
    }
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      userProfile: UserProfile? = nil,
      pet: Pet? = nil) {
    self.init(id: id,
      userProfile: userProfile,
      pet: pet,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      userProfile: UserProfile? = nil,
      pet: Pet? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self._userProfile = LazyReference(userProfile)
      self._pet = LazyReference(pet)
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
  public mutating func setUserProfile(_ userProfile: UserProfile? = nil) {
    self._userProfile = LazyReference(userProfile)
  }
  public mutating func setPet(_ pet: Pet? = nil) {
    self._pet = LazyReference(pet)
  }
  public init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      id = try values.decode(String.self, forKey: .id)
      _userProfile = try values.decodeIfPresent(LazyReference<UserProfile>.self, forKey: .userProfile) ?? LazyReference(identifiers: nil)
      _pet = try values.decodeIfPresent(LazyReference<Pet>.self, forKey: .pet) ?? LazyReference(identifiers: nil)
      createdAt = try? values.decode(Temporal.DateTime?.self, forKey: .createdAt)
      updatedAt = try? values.decode(Temporal.DateTime?.self, forKey: .updatedAt)
  }
  public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(id, forKey: .id)
      try container.encode(_userProfile, forKey: .userProfile)
      try container.encode(_pet, forKey: .pet)
      try container.encode(createdAt, forKey: .createdAt)
      try container.encode(updatedAt, forKey: .updatedAt)
  }
}