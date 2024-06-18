// swiftlint:disable all
import Amplify
import Foundation

public struct Pet: Model {
  public let id: String
  public var description: String?
  public var name: String?
  public var age: Int?
  public var petImage: Bool?
  internal var _petType: LazyReference<PetType>
  public var petType: PetType?   {
      get async throws { 
        try await _petType.get()
      } 
    }
  internal var _petBreed: LazyReference<PetBreed>
  public var petBreed: PetBreed?   {
      get async throws { 
        try await _petBreed.get()
      } 
    }
  public var userProfiles: List<UserProfilePet>?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      description: String? = nil,
      name: String? = nil,
      age: Int? = nil,
      petImage: Bool? = nil,
      petType: PetType? = nil,
      petBreed: PetBreed? = nil,
      userProfiles: List<UserProfilePet>? = []) {
    self.init(id: id,
      description: description,
      name: name,
      age: age,
      petImage: petImage,
      petType: petType,
      petBreed: petBreed,
      userProfiles: userProfiles,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      description: String? = nil,
      name: String? = nil,
      age: Int? = nil,
      petImage: Bool? = nil,
      petType: PetType? = nil,
      petBreed: PetBreed? = nil,
      userProfiles: List<UserProfilePet>? = [],
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.description = description
      self.name = name
      self.age = age
      self.petImage = petImage
      self._petType = LazyReference(petType)
      self._petBreed = LazyReference(petBreed)
      self.userProfiles = userProfiles
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
  public mutating func setPetType(_ petType: PetType? = nil) {
    self._petType = LazyReference(petType)
  }
  public mutating func setPetBreed(_ petBreed: PetBreed? = nil) {
    self._petBreed = LazyReference(petBreed)
  }
  public init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      id = try values.decode(String.self, forKey: .id)
      description = try? values.decode(String?.self, forKey: .description)
      name = try? values.decode(String?.self, forKey: .name)
      age = try? values.decode(Int?.self, forKey: .age)
      petImage = try? values.decode(Bool?.self, forKey: .petImage)
      _petType = try values.decodeIfPresent(LazyReference<PetType>.self, forKey: .petType) ?? LazyReference(identifiers: nil)
      _petBreed = try values.decodeIfPresent(LazyReference<PetBreed>.self, forKey: .petBreed) ?? LazyReference(identifiers: nil)
      userProfiles = try values.decodeIfPresent(List<UserProfilePet>?.self, forKey: .userProfiles) ?? .init()
      createdAt = try? values.decode(Temporal.DateTime?.self, forKey: .createdAt)
      updatedAt = try? values.decode(Temporal.DateTime?.self, forKey: .updatedAt)
  }
  public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(id, forKey: .id)
      try container.encode(description, forKey: .description)
      try container.encode(name, forKey: .name)
      try container.encode(age, forKey: .age)
      try container.encode(petImage, forKey: .petImage)
      try container.encode(_petType, forKey: .petType)
      try container.encode(_petBreed, forKey: .petBreed)
      try container.encode(userProfiles, forKey: .userProfiles)
      try container.encode(createdAt, forKey: .createdAt)
      try container.encode(updatedAt, forKey: .updatedAt)
  }
}