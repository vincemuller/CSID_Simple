// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "7341af5ec5daa8d95e36bacd0ea88535"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: SavedMeals.self)
    ModelRegistry.register(modelType: Meals.self)
    ModelRegistry.register(modelType: SavedFoods.self)
    ModelRegistry.register(modelType: SavedLists.self)
    ModelRegistry.register(modelType: TolerationRating.self)
  }
}