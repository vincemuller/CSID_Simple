//
//  Singletons.swift
//  CSID_Simple
//
//  Created by Vince Muller on 11/2/24.
//

import Foundation
import Amplify
import AWSPluginsCore
import AWSAPIPlugin


nonisolated(unsafe) public var databasePointer: OpaquePointer!

@MainActor
class User: ObservableObject {
    
    let userID: String? = "vmuller2529"
    @Published var userSavedLists: [SavedLists] = []
    @Published var userSavedFoods: [SavedFoods] = []
    
    //User Daily Thresholds
    @Published var dailyThresholds: DailyThresholds = DailyThresholds(dailyTotalCarbsThreshold: 100, dailyNetCarbsThreshold: 90, dailySugarsThreshold: 45, dailyStarchesThreshold: 45)
    
    //New Date and Week Variables
    @Published var calendar = Calendar.current
    @Published var dates: [Date] = []
    @Published var selectedDay: Date = Date().getNormalizedDate(adjustor: 0)
    
    @Published var weeklyMeals: List<Meals> = []
    @Published var dailyMeals: [Meals] = []
    @Published var dailyMeal: Meals = Meals()
    @Published var dailyMealFoods: [DailyMealFoods] = []
    @Published var dailyTotalCarbs: Float = 0
    @Published var dailyNetCarbs: Float = 0
    @Published var dailyTotalSugars: Float = 0
    @Published var dailyTotalStarches: Float = 0
    
    

    init(){
        updateWeek()
    }
    
    func updateWeek(dayInterval: Double = 0) {
        let today = calendar.startOfDay(for: selectedDay).addingTimeInterval(.days(dayInterval))
        let dayOfWeek = calendar.component(.weekday, from: today)
        dates = calendar.range(of: .weekday, in: .weekOfYear, for: today)!.compactMap({calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: today)})
    }
    
    //Function to get user's weekly meals from Amplify
    func getWeeklyMeals() async {
        let d = Temporal.Date.init(selectedDay.addingTimeInterval(.days(-7)), timeZone: .autoupdatingCurrent)
        let meals = Meals.keys
        let predicate = meals.userID == userID && meals.mealDate > d && meals.mealDate <= Temporal.Date.init(selectedDay.addingTimeInterval(.days(6)), timeZone: .autoupdatingCurrent)
        let request = GraphQLRequest<Meals>.list(Meals.self, where: predicate)
        do {
            let result = try await Amplify.API.query(request: request)
            switch result {
            case .success(let meals):
                print("Successfully retrieved meals: \(meals.count)")
                
                DispatchQueue.main.async {
                    self.weeklyMeals = meals
                    self.getDailyMealDataTotals()
                }

            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
            }
        } catch let error as APIError {
            print("Failed to query saved lists: ", error)
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    //Function to log new meal to Amplify
    func logNewMeal(meal: Meal) async {
        let model = Meals(
            userID: self.userID,
            mealDate: meal.mealDate,
            mealType: meal.mealType,
            foods:  meal.getMealJSON(),
            savedMeals: meal.getMealJSON(),
            additionalNotes: meal.additionalNotes
            )
        
        do {
            let result = try await Amplify.API.mutate(request: .create(model))
            switch result {
            case .success(let model):
                print("Successfully created Meals: \(model)")
            case .failure(let graphQLError):
                print("Failed to create graphql \(graphQLError)")
            }
        } catch let error as APIError {
            print("Failed to create Meals - \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    //Function to update foods for a daily meal in Amplify
    func updateMeal(selectedFood: FoodDetails, consumedServings: Float) {
        var mealFoods: [MealFood] = dailyMeal.decodeFoodJSON()
        
        mealFoods.append(MealFood(fdicID: selectedFood.fdicID, brandOwner: selectedFood.brandOwner, brandName: selectedFood.brandName, description: selectedFood.description, consumedServings: consumedServings, totalCarbs: ((Float(selectedFood.carbs) ?? 0) * (Float(consumedServings))).description, totalFiber: "", netCarbs: "", totalSugars: ((Float(selectedFood.totalSugars) ?? 0) * (Float(consumedServings))).description, totalStarches: ((Float(selectedFood.totalStarches) ?? 0) * (Float(consumedServings))).description, wholeFood: selectedFood.wholeFood))
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted

        do {
            let encodeMeal = try jsonEncoder.encode(mealFoods)
            dailyMeal.foods = String(data: encodeMeal, encoding: .utf8)!
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateMealFood(mealFood: MealFood) {
        var mealFoods: [MealFood] = dailyMeal.decodeFoodJSON()
        
        if let row = mealFoods.firstIndex(where: {$0.id == mealFood.id}) {
            mealFoods[row] = mealFood
        }
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        
        do {
            let encodeMeal = try jsonEncoder.encode(mealFoods)
            dailyMeal.foods = String(data: encodeMeal, encoding: .utf8)!
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //Function to delete daily meal should the meal no longer have any foods or meals
    func deleteMeal() async {
        do {
            let result = try await Amplify.API.mutate(request: .delete(dailyMeal))
            switch result {
            case .success(let model):
                print("Successfully deleted Meals: \(model)")
            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
            }
        } catch let error as APIError {
            print("Failed to delete Meals - \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func dailyMealCheck(mealType: String) -> Bool {
        let sD = Temporal.Date.init(selectedDay, timeZone: .none)
        let d = weeklyMeals.filter {$0.mealDate?.iso8601FormattedString(format: .short) == sD.iso8601FormattedString(format: .short) }
        
        if (d.first(where: {$0.mealType == mealType}) ?? Meals()).mealType != nil {
            return true
        }
        
        return false
    }
    
    func filterDailyMeal(mealType: String) {
        let sD = Temporal.Date.init(selectedDay, timeZone: .none)
        let d = weeklyMeals.filter {$0.mealDate?.iso8601FormattedString(format: .short) == sD.iso8601FormattedString(format: .short) }
        dailyMeal = d.first(where: {$0.mealType == mealType}) ?? Meals()
    }
    
    func updateDailyMeals() async {
        do {
            let result = try await Amplify.API.mutate(request: .update(dailyMeal))
            switch result {
            case .success(let model):
                print("Successfully updated daily meal: \(model)")

            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
            }
        } catch let error as APIError {
            print("Failed to update SavedLists - \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    func getDailyMealDataTotals() {
        let sD = Temporal.Date.init(selectedDay, timeZone: .none)
        let d = weeklyMeals.filter {$0.mealDate?.iso8601FormattedString(format: .short) == sD.iso8601FormattedString(format: .short) }
        
        var tC: Float = 0
        var tSug: Float = 0
        var tStar: Float = 0
        
        for i in d {
            for f in i.decodeFoodJSON() {
                tC = tC + (Float(f.totalCarbs) ?? 0)
                tSug = tSug + (Float(f.totalSugars) ?? 0)
                tStar = tStar + (Float(f.totalStarches) ?? 0)
            }
        }
        
        dailyTotalCarbs = tC
        dailyTotalSugars = tSug
        dailyTotalStarches = tStar

    }
    
    
    func getSavedLists() async {
        let lists = SavedLists.keys
        let predicate = lists.userID == userID
        let request = GraphQLRequest<SavedLists>.list(SavedLists.self, where: predicate)
        do {
            let result = try await Amplify.API.query(request: request)
            switch result {
            case .success(let lists):
                print("Successfully retrieved saved lists: \(lists.count)")
                DispatchQueue.main.async {
                    self.userSavedLists.removeAll()
                }
                for l in lists {
                    DispatchQueue.main.async {
                        self.userSavedLists.append(l)
                    }
                }
            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
//                errorAlert = true
//                errorComment = error.errorDescription
            }
        } catch let error as APIError {
            print("Failed to query saved lists: ", error)
//            errorAlert = true
//            errorComment = error.errorDescription
        } catch {
            print("Unexpected error: \(error)")
//            errorAlert = true
//            errorComment = error.localizedDescription
        }
    }
    
    func getSavedFoods() async {
        let foods = SavedFoods.keys
        let predicate = foods.userID == userID
        let request = GraphQLRequest<SavedFoods>.list(SavedFoods.self, where: predicate)
        do {
            let result = try await Amplify.API.query(request: request)
            switch result {
            case .success(let foods):
                print("Successfully retrieved saved foods: \(foods.count)")
                DispatchQueue.main.async {
                    self.userSavedFoods.removeAll()
                }
                for l in foods {
                    DispatchQueue.main.async {
                        self.userSavedFoods.append(l)
                    }
                }
            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
//                errorAlert = true
//                errorComment = error.errorDescription
            }
        } catch let error as APIError {
            print("Failed to query saved foods: ", error)
//            errorAlert = true
//            errorComment = error.errorDescription
        } catch {
            print("Unexpected error: \(error)")
//            errorAlert = true
//            errorComment = error.localizedDescription
        }
    }
}
