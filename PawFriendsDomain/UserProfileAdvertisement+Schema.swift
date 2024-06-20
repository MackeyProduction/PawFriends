// swiftlint:disable all
import Amplify
import Foundation

extension UserProfileAdvertisement {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case userProfile
    case advertisement
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let userProfileAdvertisement = UserProfileAdvertisement.keys
    
    model.authRules = [
      rule(allow: .public, provider: .iam, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "UserProfileAdvertisements"
    model.syncPluralName = "UserProfileAdvertisements"
    
    model.attributes(
      .primaryKey(fields: [userProfileAdvertisement.id])
    )
    
    model.fields(
      .field(userProfileAdvertisement.id, is: .required, ofType: .string),
      .belongsTo(userProfileAdvertisement.userProfile, is: .optional, ofType: UserProfile.self, targetNames: ["userProfileId"]),
      .belongsTo(userProfileAdvertisement.advertisement, is: .optional, ofType: Advertisement.self, targetNames: ["advertisementId"]),
      .field(userProfileAdvertisement.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(userProfileAdvertisement.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
    public class Path: ModelPath<UserProfileAdvertisement> { }
    
    public static var rootPath: PropertyContainerPath? { Path() }
}

extension UserProfileAdvertisement: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}
extension ModelPath where ModelType == UserProfileAdvertisement {
  public var id: FieldPath<String>   {
      string("id") 
    }
  public var userProfile: ModelPath<UserProfile>   {
      UserProfile.Path(name: "userProfile", parent: self) 
    }
  public var advertisement: ModelPath<Advertisement>   {
      Advertisement.Path(name: "advertisement", parent: self) 
    }
  public var createdAt: FieldPath<Temporal.DateTime>   {
      datetime("createdAt") 
    }
  public var updatedAt: FieldPath<Temporal.DateTime>   {
      datetime("updatedAt") 
    }
}