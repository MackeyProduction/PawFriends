// swiftlint:disable all
import Amplify
import Foundation

public struct Pet: Model {
  public let id: String
  public var petId: String?
  public var description: String?
  public var name: String?
  public var age: Int?
  public var petImage: Bool?
  internal var _currentPetType: LazyReference<PetType>
  public var currentPetType: PetType?   {
      get async throws { 
        try await _currentPetType.get()
      } 
    }
  internal var _currentPetBreed: LazyReference<PetBreed>
  public var currentPetBreed: PetBreed?   {
      get async throws { 
        try await _currentPetBreed.get()
      } 
    }
  public var userProfiles: List<UserProfilePet>?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      petId: String? = nil,
      description: String? = nil,
      name: String? = nil,
      age: Int? = nil,
      petImage: Bool? = nil,
      currentPetType: PetType? = nil,
      currentPetBreed: PetBreed? = nil,
      userProfiles: List<UserProfilePet>? = []) {
    self.init(id: id,
      petId: petId,
      description: description,
      name: name,
      age: age,
      petImage: petImage,
      currentPetType: currentPetType,
      currentPetBreed: currentPetBreed,
      userProfiles: userProfiles,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      petId: String? = nil,
      description: String? = nil,
      name: String? = nil,
      age: Int? = nil,
      petImage: Bool? = nil,
      currentPetType: PetType? = nil,
      currentPetBreed: PetBreed? = nil,
      userProfiles: List<UserProfilePet>? = [],
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.petId = petId
      self.description = description
      self.name = name
      self.age = age
      self.petImage = petImage
      self._currentPetType = LazyReference(currentPetType)
      self._currentPetBreed = LazyReference(currentPetBreed)
      self.userProfiles = userProfiles
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
  public mutating func setCurrentPetType(_ currentPetType: PetType? = nil) {
    self._currentPetType = LazyReference(currentPetType)
  }
  public mutating func setCurrentPetBreed(_ currentPetBreed: PetBreed? = nil) {
    self._currentPetBreed = LazyReference(currentPetBreed)
  }
  public init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      id = try values.decode(String.self, forKey: .id)
      petId = try? values.decode(String?.self, forKey: .petId)
      description = try? values.decode(String?.self, forKey: .description)
      name = try? values.decode(String?.self, forKey: .name)
      age = try? values.decode(Int?.self, forKey: .age)
      petImage = try? values.decode(Bool?.self, forKey: .petImage)
      _currentPetType = try values.decodeIfPresent(LazyReference<PetType>.self, forKey: .currentPetType) ?? LazyReference(identifiers: nil)
      _currentPetBreed = try values.decodeIfPresent(LazyReference<PetBreed>.self, forKey: .currentPetBreed) ?? LazyReference(identifiers: nil)
      userProfiles = try values.decodeIfPresent(List<UserProfilePet>?.self, forKey: .userProfiles) ?? .init()
      createdAt = try? values.decode(Temporal.DateTime?.self, forKey: .createdAt)
      updatedAt = try? values.decode(Temporal.DateTime?.self, forKey: .updatedAt)
  }
  public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(id, forKey: .id)
      try container.encode(petId, forKey: .petId)
      try container.encode(description, forKey: .description)
      try container.encode(name, forKey: .name)
      try container.encode(age, forKey: .age)
      try container.encode(petImage, forKey: .petImage)
      try container.encode(_currentPetType, forKey: .currentPetType)
      try container.encode(_currentPetBreed, forKey: .currentPetBreed)
      try container.encode(userProfiles, forKey: .userProfiles)
      try container.encode(createdAt, forKey: .createdAt)
      try container.encode(updatedAt, forKey: .updatedAt)
  }
}