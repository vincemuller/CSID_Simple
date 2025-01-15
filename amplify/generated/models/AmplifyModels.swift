// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "cd026762b91ef1a4685cd253250f4251"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Meals.self)
    ModelRegistry.register(modelType: SavedFoods.self)
    ModelRegistry.register(modelType: SavedLists.self)
    ModelRegistry.register(modelType: TolerationRating.self)
  }
}