// swiftlint:disable all
import Amplify
import Foundation

extension UserProfile {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case userProfileId
    case description
    case activeSince
    case profileImage
    case location
    case author
    case tags
    case pets
    case watchLists
    case advertisements
    case chats
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let userProfile = UserProfile.keys
    
    model.authRules = [
      rule(allow: .owner, ownerField: "author", identityClaim: "cognito:username", provider: .userPools, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "UserProfiles"
    model.syncPluralName = "UserProfiles"
    
    model.attributes(
      .primaryKey(fields: [userProfile.id])
    )
    
    model.fields(
      .field(userProfile.id, is: .required, ofType: .string),
      .field(userProfile.userProfileId, is: .optional, ofType: .string),
      .field(userProfile.description, is: .optional, ofType: .string),
      .field(userProfile.activeSince, is: .optional, ofType: .date),
      .field(userProfile.profileImage, is: .optional, ofType: .bool),
      .field(userProfile.location, is: .optional, ofType: .string),
      .field(userProfile.author, is: .optional, ofType: .string),
      .hasMany(userProfile.tags, is: .optional, ofType: UserProfileTag.self, associatedFields: [UserProfileTag.keys.userProfile]),
      .hasMany(userProfile.pets, is: .optional, ofType: Pet.self, associatedFields: [Pet.keys.userProfile]),
      .hasMany(userProfile.watchLists, is: .optional, ofType: WatchList.self, associatedFields: [WatchList.keys.userProfile]),
      .hasMany(userProfile.advertisements, is: .optional, ofType: Advertisement.self, associatedFields: [Advertisement.keys.userProfile]),
      .hasMany(userProfile.chats, is: .optional, ofType: Chat.self, associatedFields: [Chat.keys.userProfile]),
      .field(userProfile.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(userProfile.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
    public class Path: ModelPath<UserProfile> { }
    
    public static var rootPath: PropertyContainerPath? { Path() }
}

extension UserProfile: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}
extension ModelPath where ModelType == UserProfile {
  public var id: FieldPath<String>   {
      string("id") 
    }
  public var userProfileId: FieldPath<String>   {
      string("userProfileId") 
    }
  public var description: FieldPath<String>   {
      string("description") 
    }
  public var activeSince: FieldPath<Temporal.Date>   {
      date("activeSince") 
    }
  public var profileImage: FieldPath<Bool>   {
      bool("profileImage") 
    }
  public var location: FieldPath<String>   {
      string("location") 
    }
  public var author: FieldPath<String>   {
      string("author") 
    }
  public var tags: ModelPath<UserProfileTag>   {
      UserProfileTag.Path(name: "tags", isCollection: true, parent: self) 
    }
  public var pets: ModelPath<Pet>   {
      Pet.Path(name: "pets", isCollection: true, parent: self) 
    }
  public var watchLists: ModelPath<WatchList>   {
      WatchList.Path(name: "watchLists", isCollection: true, parent: self) 
    }
  public var advertisements: ModelPath<Advertisement>   {
      Advertisement.Path(name: "advertisements", isCollection: true, parent: self) 
    }
  public var chats: ModelPath<Chat>   {
      Chat.Path(name: "chats", isCollection: true, parent: self) 
    }
  public var createdAt: FieldPath<Temporal.DateTime>   {
      datetime("createdAt") 
    }
  public var updatedAt: FieldPath<Temporal.DateTime>   {
      datetime("updatedAt") 
    }
}