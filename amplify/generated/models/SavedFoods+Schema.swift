// swiftlint:disable all
import Amplify
import Foundation

extension SavedFoods {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case savedListsID
    case userID
    case fdicID
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let savedFoods = SavedFoods.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "SavedFoods"
    model.syncPluralName = "SavedFoods"
    
    model.attributes(
      .primaryKey(fields: [savedFoods.id])
    )
    
    model.fields(
      .field(savedFoods.id, is: .required, ofType: .string),
      .field(savedFoods.savedListsID, is: .optional, ofType: .string),
      .field(savedFoods.userID, is: .optional, ofType: .string),
      .field(savedFoods.fdicID, is: .optional, ofType: .int),
      .field(savedFoods.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(savedFoods.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension SavedFoods: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}