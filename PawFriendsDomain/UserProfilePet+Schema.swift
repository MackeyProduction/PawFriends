// swiftlint:disable all
import Amplify
import Foundation

extension UserProfilePet {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case userProfile
    case pet
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let userProfilePet = UserProfilePet.keys
    
    model.authRules = [
      rule(allow: .public, provider: .iam, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "UserProfilePets"
    model.syncPluralName = "UserProfilePets"
    
    model.attributes(
      .primaryKey(fields: [userProfilePet.id])
    )
    
    model.fields(
      .field(userProfilePet.id, is: .required, ofType: .string),
      .belongsTo(userProfilePet.userProfile, is: .optional, ofType: UserProfile.self, targetNames: ["userProfileId"]),
      .belongsTo(userProfilePet.pet, is: .optional, ofType: Pet.self, targetNames: ["petId"]),
      .field(userProfilePet.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(userProfilePet.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
    public class Path: ModelPath<UserProfilePet> { }
    
    public static var rootPath: PropertyContainerPath? { Path() }
}

extension UserProfilePet: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}
extension ModelPath where ModelType == UserProfilePet {
  public var id: FieldPath<String>   {
      string("id") 
    }
  public var userProfile: ModelPath<UserProfile>   {
      UserProfile.Path(name: "userProfile", parent: self) 
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