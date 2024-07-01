// swiftlint:disable all
import Amplify
import Foundation

extension Pet {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case description
    case name
    case age
    case petImage
    case author
    case petType
    case petBreed
    case userProfile
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let pet = Pet.keys
    
    model.authRules = [
      rule(allow: .owner, ownerField: "author", identityClaim: "cognito:username", provider: .userPools, operations: [.create, .update, .delete, .read]),
      rule(allow: .private, operations: [.read])
    ]
    
    model.listPluralName = "Pets"
    model.syncPluralName = "Pets"
    
    model.attributes(
      .primaryKey(fields: [pet.id])
    )
    
    model.fields(
      .field(pet.id, is: .required, ofType: .string),
      .field(pet.description, is: .optional, ofType: .string),
      .field(pet.name, is: .optional, ofType: .string),
      .field(pet.age, is: .optional, ofType: .int),
      .field(pet.petImage, is: .optional, ofType: .bool),
      .field(pet.author, is: .optional, ofType: .string),
      .belongsTo(pet.petType, is: .optional, ofType: PetType.self, targetNames: ["petId"]),
      .belongsTo(pet.petBreed, is: .optional, ofType: PetBreed.self, targetNames: ["petId"]),
      .belongsTo(pet.userProfile, is: .optional, ofType: UserProfile.self, targetNames: ["userProfileId"]),
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
  public var author: FieldPath<String>   {
      string("author") 
    }
  public var petType: ModelPath<PetType>   {
      PetType.Path(name: "petType", parent: self) 
    }
  public var petBreed: ModelPath<PetBreed>   {
      PetBreed.Path(name: "petBreed", parent: self) 
    }
  public var userProfile: ModelPath<UserProfile>   {
      UserProfile.Path(name: "userProfile", parent: self) 
    }
  public var createdAt: FieldPath<Temporal.DateTime>   {
      datetime("createdAt") 
    }
  public var updatedAt: FieldPath<Temporal.DateTime>   {
      datetime("updatedAt") 
    }
}