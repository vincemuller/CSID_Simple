// swiftlint:disable all
import Amplify
import Foundation

public struct SavedLists: Model, Equatable {
  public let id: String
  public var defaultList: Bool?
  public var name: String?
  public var userID: String?
  public var description: String?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      defaultList: Bool? = nil,
      name: String? = nil,
      userID: String? = nil,
      description: String? = nil) {
    self.init(id: id,
      defaultList: defaultList,
      name: name,
      userID: userID,
      description: description,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      defaultList: Bool? = nil,
      name: String? = nil,
      userID: String? = nil,
      description: String? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.defaultList = defaultList
      self.name = name
      self.userID = userID
      self.description = description
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}
