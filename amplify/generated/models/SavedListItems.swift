// swiftlint:disable all
import Amplify
import Foundation

public struct SavedListItems: Model {
  public let id: String
  public var savedListsID: String?
  public var fdicID: String?
  public var searchKeyWords: String?
  public var brandOwner: String?
  public var brandName: String?
  public var brandedFoodCategory: String?
  public var description: String?
  public var servingSize: Double?
  public var servingSizeUnit: String?
  public var carbs: String?
  public var totalSugars: String?
  public var totalStarches: String?
  public var wholeFood: String?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      savedListsID: String? = nil,
      fdicID: String? = nil,
      searchKeyWords: String? = nil,
      brandOwner: String? = nil,
      brandName: String? = nil,
      brandedFoodCategory: String? = nil,
      description: String? = nil,
      servingSize: Double? = nil,
      servingSizeUnit: String? = nil,
      carbs: String? = nil,
      totalSugars: String? = nil,
      totalStarches: String? = nil,
      wholeFood: String? = nil) {
    self.init(id: id,
      savedListsID: savedListsID,
      fdicID: fdicID,
      searchKeyWords: searchKeyWords,
      brandOwner: brandOwner,
      brandName: brandName,
      brandedFoodCategory: brandedFoodCategory,
      description: description,
      servingSize: servingSize,
      servingSizeUnit: servingSizeUnit,
      carbs: carbs,
      totalSugars: totalSugars,
      totalStarches: totalStarches,
      wholeFood: wholeFood,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      savedListsID: String? = nil,
      fdicID: String? = nil,
      searchKeyWords: String? = nil,
      brandOwner: String? = nil,
      brandName: String? = nil,
      brandedFoodCategory: String? = nil,
      description: String? = nil,
      servingSize: Double? = nil,
      servingSizeUnit: String? = nil,
      carbs: String? = nil,
      totalSugars: String? = nil,
      totalStarches: String? = nil,
      wholeFood: String? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.savedListsID = savedListsID
      self.fdicID = fdicID
      self.searchKeyWords = searchKeyWords
      self.brandOwner = brandOwner
      self.brandName = brandName
      self.brandedFoodCategory = brandedFoodCategory
      self.description = description
      self.servingSize = servingSize
      self.servingSizeUnit = servingSizeUnit
      self.carbs = carbs
      self.totalSugars = totalSugars
      self.totalStarches = totalStarches
      self.wholeFood = wholeFood
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}