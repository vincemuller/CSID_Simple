// swiftlint:disable all
import Amplify
import Foundation

public struct TolerationRating: Model {
  public let id: String
  public var fdicID: Int?
  public var comment: String?
  public var userID: String?
  public var rating: String?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      fdicID: Int? = nil,
      comment: String? = nil,
      userID: String? = nil,
      rating: String? = nil) {
    self.init(id: id,
      fdicID: fdicID,
      comment: comment,
      userID: userID,
      rating: rating,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      fdicID: Int? = nil,
      comment: String? = nil,
      userID: String? = nil,
      rating: String? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.fdicID = fdicID
      self.comment = comment
      self.userID = userID
      self.rating = rating
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}
