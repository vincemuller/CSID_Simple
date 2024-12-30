// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "0c8529c1ce733da568bbeffb2f3e1de9"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: TolerationRating.self)
  }
}