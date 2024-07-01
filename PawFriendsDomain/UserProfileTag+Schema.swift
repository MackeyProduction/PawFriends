// swiftlint:disable all
import Amplify
import Foundation

extension UserProfileTag {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case author
    case userProfile
    case tag
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let userProfileTag = UserProfileTag.keys
    
    model.authRules = [
      rule(allow: .owner, ownerField: "author", identityClaim: "cognito:username", provider: .userPools, operations: [.create, .update, .delete, .read]),
      rule(allow: .private, operations: [.read])
    ]
    
    model.listPluralName = "UserProfileTags"
    model.syncPluralName = "UserProfileTags"
    
    model.attributes(
      .primaryKey(fields: [userProfileTag.id])
    )
    
    model.fields(
      .field(userProfileTag.id, is: .required, ofType: .string),
      .field(userProfileTag.author, is: .optional, ofType: .string),
      .belongsTo(userProfileTag.userProfile, is: .optional, ofType: UserProfile.self, targetNames: ["userProfileId"]),
      .belongsTo(userProfileTag.tag, is: .optional, ofType: Tag.self, targetNames: ["tagId"]),
      .field(userProfileTag.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(userProfileTag.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
    public class Path: ModelPath<UserProfileTag> { }
    
    public static var rootPath: PropertyContainerPath? { Path() }
}

extension UserProfileTag: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}
extension ModelPath where ModelType == UserProfileTag {
  public var id: FieldPath<String>   {
      string("id") 
    }
  public var author: FieldPath<String>   {
      string("author") 
    }
  public var userProfile: ModelPath<UserProfile>   {
      UserProfile.Path(name: "userProfile", parent: self) 
    }
  public var tag: ModelPath<Tag>   {
      Tag.Path(name: "tag", parent: self) 
    }
  public var createdAt: FieldPath<Temporal.DateTime>   {
      datetime("createdAt") 
    }
  public var updatedAt: FieldPath<Temporal.DateTime>   {
      datetime("updatedAt") 
    }
}