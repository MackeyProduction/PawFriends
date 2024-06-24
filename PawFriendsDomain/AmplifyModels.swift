// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "6d2fe2e281c70dfe50aa8841680e38dd"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: UserProfile.self)
    ModelRegistry.register(modelType: Pet.self)
    ModelRegistry.register(modelType: PetType.self)
    ModelRegistry.register(modelType: PetBreed.self)
    ModelRegistry.register(modelType: Chat.self)
    ModelRegistry.register(modelType: Advertisement.self)
    ModelRegistry.register(modelType: Tag.self)
    ModelRegistry.register(modelType: UserProfileTag.self)
    ModelRegistry.register(modelType: AdvertisementTag.self)
    ModelRegistry.register(modelType: WatchList.self)
    ModelRegistry.register(modelType: UserProfileFollower.self)
  }
}