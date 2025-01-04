// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "7e061e57201eab9b481eb4bf6a3a229b"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: SavedListItems.self)
    ModelRegistry.register(modelType: SavedLists.self)
    ModelRegistry.register(modelType: TolerationRating.self)
  }
}