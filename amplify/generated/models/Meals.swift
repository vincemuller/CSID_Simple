// swiftlint:disable all
import Amplify
import Foundation

public struct Meals: Model {
  public let id: String
  public var userID: String?
  public var mealDate: Temporal.Date?
  public var mealType: String?
  public var foods: String?
  public var savedMeals: String?
  public var additionalNotes: String?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      userID: String? = nil,
      mealDate: Temporal.Date? = nil,
      mealType: String? = nil,
      foods: String? = nil,
      savedMeals: String? = nil,
      additionalNotes: String? = nil) {
    self.init(id: id,
      userID: userID,
      mealDate: mealDate,
      mealType: mealType,
      foods: foods,
      savedMeals: savedMeals,
      additionalNotes: additionalNotes,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      userID: String? = nil,
      mealDate: Temporal.Date? = nil,
      mealType: String? = nil,
      foods: String? = nil,
      savedMeals: String? = nil,
      additionalNotes: String? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.userID = userID
      self.mealDate = mealDate
      self.mealType = mealType
      self.foods = foods
      self.savedMeals = savedMeals
      self.additionalNotes = additionalNotes
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
    
    func decodeFoodJSON() -> [MealFood] {
        var decodedFood: [MealFood] = []
        let jsonDecoder = JSONDecoder()
        
        if foods != nil {
            do {
                decodedFood = try jsonDecoder.decode([MealFood].self, from: Data(self.foods?.utf8 ?? "".utf8))
            } catch {
                print(error.localizedDescription)
                decodedFood = [
                    MealFood(fdicID: 1001, description: "Snickers Crunchers, Chocolate Bar", consumedServings: 1.5, totalCarbs: "25", totalFiber: "1", netCarbs: "24", totalSugars: "22", totalStarches: "2", wholeFood: "none"),
                    MealFood(fdicID: 1100, description: "Ham Sandwich", consumedServings: 1.0, totalCarbs: "45", totalFiber: "5", netCarbs: "40", totalSugars: "12", totalStarches: "28", wholeFood: "none")]
            }
            
            return decodedFood
        } else {
            return []
        }
    }
}
