// swiftlint:disable all
import Amplify
import Foundation

public struct Meals: Model {
  public let id: String
  public var userID: String?
  public var mealType: String?
  public var mealName: String?
  public var foods: String?
  public var additionalNotes: String?
  public var tolerationRating: String?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      userID: String? = nil,
      mealType: String? = nil,
      mealName: String? = nil,
      foods: String? = nil,
      additionalNotes: String? = nil,
      tolerationRating: String? = nil) {
    self.init(id: id,
      userID: userID,
      mealType: mealType,
      mealName: mealName,
      foods: foods,
      additionalNotes: additionalNotes,
      tolerationRating: tolerationRating,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      userID: String? = nil,
      mealType: String? = nil,
      mealName: String? = nil,
      foods: String? = nil,
      additionalNotes: String? = nil,
      tolerationRating: String? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.userID = userID
      self.mealType = mealType
      self.mealName = mealName
      self.foods = foods
      self.additionalNotes = additionalNotes
      self.tolerationRating = tolerationRating
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}
