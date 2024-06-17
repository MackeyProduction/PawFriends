// swiftlint:disable all
import Amplify
import Foundation

extension PetBreed {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case description
    case pet
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
      .field(petBreed.description, is: .optional, ofType: .string),
      .belongsTo(petBreed.pet, is: .optional, ofType: Pet.self, targetNames: ["petBreedId"]),
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
  public var description: FieldPath<String>   {
      string("description") 
    }
  public var pet: ModelPath<Pet>   {
      Pet.Path(name: "pet", parent: self) 
    }
  public var createdAt: FieldPath<Temporal.DateTime>   {
      datetime("createdAt") 
    }
  public var updatedAt: FieldPath<Temporal.DateTime>   {
      datetime("updatedAt") 
    }
}