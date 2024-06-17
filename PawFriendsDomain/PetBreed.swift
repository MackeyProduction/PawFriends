// swiftlint:disable all
import Amplify
import Foundation

public struct PetBreed: Model {
  public let id: String
  public var description: String?
  internal var _pet: LazyReference<Pet>
  public var pet: Pet?   {
      get async throws { 
        try await _pet.get()
      } 
    }
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      description: String? = nil,
      pet: Pet? = nil) {
    self.init(id: id,
      description: description,
      pet: pet,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      description: String? = nil,
      pet: Pet? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.description = description
      self._pet = LazyReference(pet)
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
  public mutating func setPet(_ pet: Pet? = nil) {
    self._pet = LazyReference(pet)
  }
  public init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      id = try values.decode(String.self, forKey: .id)
      description = try? values.decode(String?.self, forKey: .description)
      _pet = try values.decodeIfPresent(LazyReference<Pet>.self, forKey: .pet) ?? LazyReference(identifiers: nil)
      createdAt = try? values.decode(Temporal.DateTime?.self, forKey: .createdAt)
      updatedAt = try? values.decode(Temporal.DateTime?.self, forKey: .updatedAt)
  }
  public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(id, forKey: .id)
      try container.encode(description, forKey: .description)
      try container.encode(_pet, forKey: .pet)
      try container.encode(createdAt, forKey: .createdAt)
      try container.encode(updatedAt, forKey: .updatedAt)
  }
}