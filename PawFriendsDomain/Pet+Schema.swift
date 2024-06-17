// swiftlint:disable all
import Amplify
import Foundation

extension Pet {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case petId
    case description
    case name
    case age
    case petImage
    case currentPetType
    case currentPetBreed
    case userProfiles
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let pet = Pet.keys
    
    model.authRules = [
      rule(allow: .public, provider: .iam, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "Pets"
    model.syncPluralName = "Pets"
    
    model.attributes(
      .primaryKey(fields: [pet.id])
    )
    
    model.fields(
      .field(pet.id, is: .required, ofType: .string),
      .field(pet.petId, is: .optional, ofType: .string),
      .field(pet.description, is: .optional, ofType: .string),
      .field(pet.name, is: .optional, ofType: .string),
      .field(pet.age, is: .optional, ofType: .int),
      .field(pet.petImage, is: .optional, ofType: .bool),
      .hasOne(pet.currentPetType, is: .optional, ofType: PetType.self, associatedFields: [PetType.keys.pet]),
      .hasOne(pet.currentPetBreed, is: .optional, ofType: PetBreed.self, associatedFields: [PetBreed.keys.pet]),
      .hasMany(pet.userProfiles, is: .optional, ofType: UserProfilePet.self, associatedFields: [UserProfilePet.keys.pet]),
      .field(pet.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(pet.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
    public class Path: ModelPath<Pet> { }
    
    public static var rootPath: PropertyContainerPath? { Path() }
}

extension Pet: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}
extension ModelPath where ModelType == Pet {
  public var id: FieldPath<String>   {
      string("id") 
    }
  public var petId: FieldPath<String>   {
      string("petId") 
    }
  public var description: FieldPath<String>   {
      string("description") 
    }
  public var name: FieldPath<String>   {
      string("name") 
    }
  public var age: FieldPath<Int>   {
      int("age") 
    }
  public var petImage: FieldPath<Bool>   {
      bool("petImage") 
    }
  public var currentPetType: ModelPath<PetType>   {
      PetType.Path(name: "currentPetType", parent: self) 
    }
  public var currentPetBreed: ModelPath<PetBreed>   {
      PetBreed.Path(name: "currentPetBreed", parent: self) 
    }
  public var userProfiles: ModelPath<UserProfilePet>   {
      UserProfilePet.Path(name: "userProfiles", isCollection: true, parent: self) 
    }
  public var createdAt: FieldPath<Temporal.DateTime>   {
      datetime("createdAt") 
    }
  public var updatedAt: FieldPath<Temporal.DateTime>   {
      datetime("updatedAt") 
    }
}