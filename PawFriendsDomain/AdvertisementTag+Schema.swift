// swiftlint:disable all
import Amplify
import Foundation

extension AdvertisementTag {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case advertisement
    case tag
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let advertisementTag = AdvertisementTag.keys
    
    model.authRules = [
      rule(allow: .public, provider: .iam, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "AdvertisementTags"
    model.syncPluralName = "AdvertisementTags"
    
    model.attributes(
      .primaryKey(fields: [advertisementTag.id])
    )
    
    model.fields(
      .field(advertisementTag.id, is: .required, ofType: .string),
      .belongsTo(advertisementTag.advertisement, is: .optional, ofType: Advertisement.self, targetNames: ["advertisementId"]),
      .belongsTo(advertisementTag.tag, is: .optional, ofType: Tag.self, targetNames: ["tagId"]),
      .field(advertisementTag.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(advertisementTag.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
    public class Path: ModelPath<AdvertisementTag> { }
    
    public static var rootPath: PropertyContainerPath? { Path() }
}

extension AdvertisementTag: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}
extension ModelPath where ModelType == AdvertisementTag {
  public var id: FieldPath<String>   {
      string("id") 
    }
  public var advertisement: ModelPath<Advertisement>   {
      Advertisement.Path(name: "advertisement", parent: self) 
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