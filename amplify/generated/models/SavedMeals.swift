// swiftlint:disable all
import Amplify
import Foundation

public struct SavedMeals: Model {
  public let id: String
  public var userID: String?
  public var mealName: String?
  public var foods: String?
  public var servings: Double?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      userID: String? = nil,
      mealName: String? = nil,
      foods: String? = nil,
      servings: Double? = nil) {
    self.init(id: id,
      userID: userID,
      mealName: mealName,
      foods: foods,
      servings: servings,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      userID: String? = nil,
      mealName: String? = nil,
      foods: String? = nil,
      servings: Double? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.userID = userID
      self.mealName = mealName
      self.foods = foods
      self.servings = servings
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}