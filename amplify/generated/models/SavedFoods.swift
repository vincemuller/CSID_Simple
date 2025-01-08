// swiftlint:disable all
import Amplify
import Foundation

public struct SavedFoods: Model {
  public let id: String
  public var savedListsID: String?
  public var userID: String?
  public var fdicID: Int?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      savedListsID: String? = nil,
      userID: String? = nil,
      fdicID: Int? = nil) {
    self.init(id: id,
      savedListsID: savedListsID,
      userID: userID,
      fdicID: fdicID,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      savedListsID: String? = nil,
      userID: String? = nil,
      fdicID: Int? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.savedListsID = savedListsID
      self.userID = userID
      self.fdicID = fdicID
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}