// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "5e171d130b22e8f4b9e3a19f2de6207f"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: SavedMeals.self)
    ModelRegistry.register(modelType: Meals.self)
    ModelRegistry.register(modelType: SavedFoods.self)
    ModelRegistry.register(modelType: SavedLists.self)
    ModelRegistry.register(modelType: TolerationRating.self)
  }
}