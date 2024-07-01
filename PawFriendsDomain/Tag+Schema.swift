// swiftlint:disable all
import Amplify
import Foundation

extension Tag {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case tagId
    case description
    case userProfiles
    case advertisements
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let tag = Tag.keys
    
    model.authRules = [
      rule(allow: .owner, ownerField: "owner", identityClaim: "cognito:username", provider: .userPools, operations: [.read]),
      rule(allow: .private, operations: [.read])
    ]
    
    model.listPluralName = "Tags"
    model.syncPluralName = "Tags"
    
    model.attributes(
      .primaryKey(fields: [tag.id])
    )
    
    model.fields(
      .field(tag.id, is: .required, ofType: .string),
      .field(tag.tagId, is: .optional, ofType: .string),
      .field(tag.description, is: .optional, ofType: .string),
      .hasMany(tag.userProfiles, is: .optional, ofType: UserProfileTag.self, associatedFields: [UserProfileTag.keys.tag]),
      .hasMany(tag.advertisements, is: .optional, ofType: AdvertisementTag.self, associatedFields: [AdvertisementTag.keys.tag]),
      .field(tag.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(tag.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
    public class Path: ModelPath<Tag> { }
    
    public static var rootPath: PropertyContainerPath? { Path() }
}

extension Tag: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}
extension ModelPath where ModelType == Tag {
  public var id: FieldPath<String>   {
      string("id") 
    }
  public var tagId: FieldPath<String>   {
      string("tagId") 
    }
  public var description: FieldPath<String>   {
      string("description") 
    }
  public var userProfiles: ModelPath<UserProfileTag>   {
      UserProfileTag.Path(name: "userProfiles", isCollection: true, parent: self) 
    }
  public var advertisements: ModelPath<AdvertisementTag>   {
      AdvertisementTag.Path(name: "advertisements", isCollection: true, parent: self) 
    }
  public var createdAt: FieldPath<Temporal.DateTime>   {
      datetime("createdAt") 
    }
  public var updatedAt: FieldPath<Temporal.DateTime>   {
      datetime("updatedAt") 
    }
}