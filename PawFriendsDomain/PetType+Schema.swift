// swiftlint:disable all
import Amplify
import Foundation

extension PetType {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case petId
    case description
    case pets
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let petType = PetType.keys
    
    model.authRules = [
      rule(allow: .public, provider: .iam, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "PetTypes"
    model.syncPluralName = "PetTypes"
    
    model.attributes(
      .primaryKey(fields: [petType.id])
    )
    
    model.fields(
      .field(petType.id, is: .required, ofType: .string),
      .field(petType.petId, is: .optional, ofType: .string),
      .field(petType.description, is: .optional, ofType: .string),
      .hasMany(petType.pets, is: .optional, ofType: Pet.self, associatedFields: [Pet.keys.petType]),
      .field(petType.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(petType.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
    public class Path: ModelPath<PetType> { }
    
    public static var rootPath: PropertyContainerPath? { Path() }
}

extension PetType: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}
extension ModelPath where ModelType == PetType {
  public var id: FieldPath<String>   {
      string("id") 
    }
  public var petId: FieldPath<String>   {
      string("petId") 
    }
  public var description: FieldPath<String>   {
      string("description") 
    }
  public var pets: ModelPath<Pet>   {
      Pet.Path(name: "pets", isCollection: true, parent: self) 
    }
  public var createdAt: FieldPath<Temporal.DateTime>   {
      datetime("createdAt") 
    }
  public var updatedAt: FieldPath<Temporal.DateTime>   {
      datetime("updatedAt") 
    }
}