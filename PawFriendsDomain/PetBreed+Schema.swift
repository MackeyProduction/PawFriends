// swiftlint:disable all
import Amplify
import Foundation

extension PetBreed {
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
    let petBreed = PetBreed.keys
    
    model.authRules = [
      rule(allow: .public, provider: .iam, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "PetBreeds"
    model.syncPluralName = "PetBreeds"
    
    model.attributes(
      .primaryKey(fields: [petBreed.id])
    )
    
    model.fields(
      .field(petBreed.id, is: .required, ofType: .string),
      .field(petBreed.petId, is: .optional, ofType: .string),
      .field(petBreed.description, is: .optional, ofType: .string),
      .hasMany(petBreed.pets, is: .optional, ofType: Pet.self, associatedFields: [Pet.keys.petType]),
      .field(petBreed.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(petBreed.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
    public class Path: ModelPath<PetBreed> { }
    
    public static var rootPath: PropertyContainerPath? { Path() }
}

extension PetBreed: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}
extension ModelPath where ModelType == PetBreed {
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