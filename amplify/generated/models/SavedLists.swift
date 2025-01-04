// swiftlint:disable all
import Amplify
import Foundation

public struct SavedLists: Model {
  public let id: String
  public var name: String?
  public var description: String?
  public var userID: String?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      name: String? = nil,
      description: String? = nil,
      userID: String? = nil) {
    self.init(id: id,
      name: name,
      description: description,
      userID: userID,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      name: String? = nil,
      description: String? = nil,
      userID: String? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.name = name
      self.description = description
      self.userID = userID
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}