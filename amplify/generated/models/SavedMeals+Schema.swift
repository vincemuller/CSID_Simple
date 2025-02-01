// swiftlint:disable all
import Amplify
import Foundation

extension SavedMeals {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case userID
    case mealName
    case foods
    case servings
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let savedMeals = SavedMeals.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "SavedMeals"
    model.syncPluralName = "SavedMeals"
    
    model.attributes(
      .primaryKey(fields: [savedMeals.id])
    )
    
    model.fields(
      .field(savedMeals.id, is: .required, ofType: .string),
      .field(savedMeals.userID, is: .optional, ofType: .string),
      .field(savedMeals.mealName, is: .optional, ofType: .string),
      .field(savedMeals.foods, is: .optional, ofType: .string),
      .field(savedMeals.servings, is: .optional, ofType: .double),
      .field(savedMeals.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(savedMeals.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension SavedMeals: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}