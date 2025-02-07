// swiftlint:disable all
import Amplify
import Foundation

extension Meals {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case userID
    case mealDate
    case mealType
    case foods
    case savedMeals
    case additionalNotes
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let meals = Meals.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "Meals"
    model.syncPluralName = "Meals"
    
    model.attributes(
      .primaryKey(fields: [meals.id])
    )
    
    model.fields(
      .field(meals.id, is: .required, ofType: .string),
      .field(meals.userID, is: .optional, ofType: .string),
      .field(meals.mealDate, is: .optional, ofType: .date),
      .field(meals.mealType, is: .optional, ofType: .string),
      .field(meals.foods, is: .optional, ofType: .string),
      .field(meals.savedMeals, is: .optional, ofType: .string),
      .field(meals.additionalNotes, is: .optional, ofType: .string),
      .field(meals.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(meals.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension Meals: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}