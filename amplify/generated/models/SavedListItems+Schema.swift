// swiftlint:disable all
import Amplify
import Foundation

extension SavedListItems {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case savedListsID
    case fdicID
    case searchKeyWords
    case brandOwner
    case brandName
    case brandedFoodCategory
    case description
    case servingSize
    case servingSizeUnit
    case carbs
    case totalSugars
    case totalStarches
    case wholeFood
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let savedListItems = SavedListItems.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "SavedListItems"
    model.syncPluralName = "SavedListItems"
    
    model.attributes(
      .primaryKey(fields: [savedListItems.id])
    )
    
    model.fields(
      .field(savedListItems.id, is: .required, ofType: .string),
      .field(savedListItems.savedListsID, is: .optional, ofType: .string),
      .field(savedListItems.fdicID, is: .optional, ofType: .string),
      .field(savedListItems.searchKeyWords, is: .optional, ofType: .string),
      .field(savedListItems.brandOwner, is: .optional, ofType: .string),
      .field(savedListItems.brandName, is: .optional, ofType: .string),
      .field(savedListItems.brandedFoodCategory, is: .optional, ofType: .string),
      .field(savedListItems.description, is: .optional, ofType: .string),
      .field(savedListItems.servingSize, is: .optional, ofType: .double),
      .field(savedListItems.servingSizeUnit, is: .optional, ofType: .string),
      .field(savedListItems.carbs, is: .optional, ofType: .string),
      .field(savedListItems.totalSugars, is: .optional, ofType: .string),
      .field(savedListItems.totalStarches, is: .optional, ofType: .string),
      .field(savedListItems.wholeFood, is: .optional, ofType: .string),
      .field(savedListItems.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(savedListItems.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension SavedListItems: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}