// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "5d7fcbe9b1b813a6ba7732e57e828b36"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: SavedFoods.self)
    ModelRegistry.register(modelType: SavedLists.self)
    ModelRegistry.register(modelType: TolerationRating.self)
  }
}