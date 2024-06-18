// swiftlint:disable all
import Amplify
import Foundation

public struct PetBreed: Model {
  public let id: String
  public var petId: String?
  public var description: String?
  public var pets: List<Pet>?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      petId: String? = nil,
      description: String? = nil,
      pets: List<Pet>? = []) {
    self.init(id: id,
      petId: petId,
      description: description,
      pets: pets,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      petId: String? = nil,
      description: String? = nil,
      pets: List<Pet>? = [],
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.petId = petId
      self.description = description
      self.pets = pets
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}