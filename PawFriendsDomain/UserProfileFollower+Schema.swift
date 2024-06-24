// swiftlint:disable all
import Amplify
import Foundation

extension UserProfileFollower {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case follower
    case followed
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let userProfileFollower = UserProfileFollower.keys
    
    model.authRules = [
      rule(allow: .public, provider: .iam, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "UserProfileFollowers"
    model.syncPluralName = "UserProfileFollowers"
    
    model.attributes(
      .primaryKey(fields: [userProfileFollower.id])
    )
    
    model.fields(
      .field(userProfileFollower.id, is: .required, ofType: .string),
      .belongsTo(userProfileFollower.follower, is: .optional, ofType: UserProfile.self, targetNames: ["followerId"]),
      .belongsTo(userProfileFollower.followed, is: .optional, ofType: UserProfile.self, targetNames: ["followedId"]),
      .field(userProfileFollower.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(userProfileFollower.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
    public class Path: ModelPath<UserProfileFollower> { }
    
    public static var rootPath: PropertyContainerPath? { Path() }
}

extension UserProfileFollower: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}
extension ModelPath where ModelType == UserProfileFollower {
  public var id: FieldPath<String>   {
      string("id") 
    }
  public var follower: ModelPath<UserProfile>   {
      UserProfile.Path(name: "follower", parent: self) 
    }
  public var followed: ModelPath<UserProfile>   {
      UserProfile.Path(name: "followed", parent: self) 
    }
  public var createdAt: FieldPath<Temporal.DateTime>   {
      datetime("createdAt") 
    }
  public var updatedAt: FieldPath<Temporal.DateTime>   {
      datetime("updatedAt") 
    }
}