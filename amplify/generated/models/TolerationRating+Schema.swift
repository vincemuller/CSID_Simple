// swiftlint:disable all
import Amplify
import Foundation

extension TolerationRating {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case fdicID
    case comment
    case userID
    case rating
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let tolerationRating = TolerationRating.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "TolerationRatings"
    model.syncPluralName = "TolerationRatings"
    
    model.attributes(
      .primaryKey(fields: [tolerationRating.id])
    )
    
    model.fields(
      .field(tolerationRating.id, is: .required, ofType: .string),
      .field(tolerationRating.fdicID, is: .optional, ofType: .int),
      .field(tolerationRating.comment, is: .optional, ofType: .string),
      .field(tolerationRating.userID, is: .optional, ofType: .string),
      .field(tolerationRating.rating, is: .optional, ofType: .string),
      .field(tolerationRating.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(tolerationRating.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}

extension TolerationRating: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}
