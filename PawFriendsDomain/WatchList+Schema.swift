// swiftlint:disable all
import Amplify
import Foundation

extension WatchList {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case author
    case userProfile
    case advertisement
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let watchList = WatchList.keys
    
    model.authRules = [
      rule(allow: .owner, ownerField: "author", identityClaim: "cognito:username", provider: .userPools, operations: [.create, .update, .delete, .read]),
      rule(allow: .private, operations: [.read])
    ]
    
    model.listPluralName = "WatchLists"
    model.syncPluralName = "WatchLists"
    
    model.attributes(
      .primaryKey(fields: [watchList.id])
    )
    
    model.fields(
      .field(watchList.id, is: .required, ofType: .string),
      .field(watchList.author, is: .optional, ofType: .string),
      .belongsTo(watchList.userProfile, is: .optional, ofType: UserProfile.self, targetNames: ["userProfileId"]),
      .belongsTo(watchList.advertisement, is: .optional, ofType: Advertisement.self, targetNames: ["advertisementId"]),
      .field(watchList.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(watchList.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
    public class Path: ModelPath<WatchList> { }
    
    public static var rootPath: PropertyContainerPath? { Path() }
}

extension WatchList: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}
extension ModelPath where ModelType == WatchList {
  public var id: FieldPath<String>   {
      string("id") 
    }
  public var author: FieldPath<String>   {
      string("author") 
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