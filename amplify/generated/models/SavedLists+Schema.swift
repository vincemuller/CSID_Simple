// swiftlint:disable all
import Amplify
import Foundation

extension SavedLists {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case name
    case description
    case userID
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let savedLists = SavedLists.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "SavedLists"
    model.syncPluralName = "SavedLists"
    
    model.attributes(
      .primaryKey(fields: [savedLists.id])
    )
    
    model.fields(
      .field(savedLists.id, is: .required, ofType: .string),
      .field(savedLists.name, is: .optional, ofType: .string),
      .field(savedLists.description, is: .optional, ofType: .string),
      .field(savedLists.userID, is: .optional, ofType: .string),
      .field(savedLists.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(savedLists.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension SavedLists: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}