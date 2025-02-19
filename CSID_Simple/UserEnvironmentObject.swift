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

struct DailyMealTotals: Identifiable {
    var id = UUID()
    var totalCarbs: String = ""
    var netCarbs: String = ""
    var totalSugars: String = ""
    var totalStarches: String = ""
}

struct WeeklyMealTotals: Identifiable {
    var id = UUID()
    var totalCarbs: String = ""
    var totalNetCarbs: String = ""
    var totalSugars: String = ""
    var totalStarches: String = ""
}

class User: ObservableObject {
    
    let userID: String?
    @Published var userSavedLists: [SavedLists]
    @Published var userSavedFoods: [SavedFoods]
    @Published var dailyMeals: List<Meals>
    @Published var dailyMeal: Meals = Meals()
    @Published var dailyMealFoods: [DailyMealFoods] = []
    @Published var dailyMealTotals: DailyMealTotals = DailyMealTotals()
    @Published var weeklyMealTotals: WeeklyMealTotals = WeeklyMealTotals()
    @Published var carbPercentage: Double = 0
    @Published var sugarsPercentage: Double = 0
    @Published var starchesPercentage: Double = 0


    init(userID: String? = "vmuller2529", userSavedLists: [SavedLists] = [], userSavedFoods: [SavedFoods] = [], dailyMeals: List<Meals> = [], dailyMealTotals: DailyMealTotals = DailyMealTotals()) {
        self.userID = userID
        self.userSavedLists = userSavedLists
        self.userSavedFoods = userSavedFoods
        self.dailyMeals = dailyMeals
        self.dailyMealTotals = dailyMealTotals
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
    
    
    func getUserMeals(selectedDay: Date) async {
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
                    self.dailyMeals = meals
                    self.getDailyMealTotals()
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
    
    func getDailyMealTotals() {
        //Build search terms "USDAFoodSearchTable.fdicID = 2700004"
        var searchTerms: [String] = []
        
//        for i in dailyMeal.decodeFoodJSON() {
//            searchTerms.append("USDAFoodSearchTable.fdicID = \(i.fdicID.description)")
//        }
        
        dailyMeals.forEach {$0.decodeFoodJSON().forEach {searchTerms.append("USDAFoodSearchTable.fdicID = \($0.fdicID.description)")}}
        
        let sT = searchTerms.joined(separator: " OR ")
        
        print(sT)
        
        DispatchQueue(label: "search.serial.queue2").async {
            var updatedDailyMealFoods: [DailyMealFoods] = []
            let queryResult = DatabaseQueries.databaseSavedFoodsSearch(searchTerms: sT, databasePointer: databasePointer)
            
            for meal in self.dailyMeals.filter {$0.mealDate == Temporal.Date.init(Date().getNormalizedDate(adjustor: 0), timeZone: .none)} {
                for i in meal.decodeFoodJSON() {
                    updatedDailyMealFoods.append(DailyMealFoods(mealFood: i, foodDetails: queryResult.first(where: {$0.fdicID == i.fdicID})))
                }
            }
            
            DispatchQueue.main.async(execute: {
                self.dailyMealFoods = updatedDailyMealFoods
                var totals = WeeklyMealTotals()
                
                for i in self.dailyMealFoods {
                    if i.foodDetails?.carbs != "N/A" {
                        var aC:  Float  = ((Float(i.foodDetails?.carbs ?? "") ?? 0)*Float(i.mealFood?.customServingPercentage ?? 0))
                        aC = aC + (Float(totals.totalCarbs) ?? 0)
                        totals.totalCarbs = String(format: "%.1f", aC)
                        
                        var aSug:  Float  = ((Float(i.foodDetails?.totalSugars ?? "") ?? 0)*Float(i.mealFood?.customServingPercentage ?? 0))
                        aSug = aSug + (Float(totals.totalSugars) ?? 0)
                        totals.totalSugars = String(format: "%.1f", aSug)
                        
                        var aStarch:  Float  = ((Float(i.foodDetails?.totalStarches ?? "") ?? 0)*Float(i.mealFood?.customServingPercentage ?? 0))
                        aStarch = aStarch + (Float(totals.totalStarches) ?? 0)
                        totals.totalStarches = String(format: "%.1f", aStarch)
                    }
                }
                
                self.weeklyMealTotals = totals
                self.carbPercentage = ((Double(self.weeklyMealTotals.totalCarbs) ?? 0)/100) * 100
                self.sugarsPercentage = ((Double(self.weeklyMealTotals.totalSugars) ?? 0)/100) * 100
                self.starchesPercentage = ((Double(self.weeklyMealTotals.totalStarches) ?? 0)/100) * 100
                
            })
        }
    }
    
    func getMealFoodDetails() {
        //Build search terms "USDAFoodSearchTable.fdicID = 2700004"
        var searchTerms: [String] = []
        
//        for i in dailyMeal.decodeFoodJSON() {
//            searchTerms.append("USDAFoodSearchTable.fdicID = \(i.fdicID.description)")
//        }
        
        dailyMeal.decodeFoodJSON().forEach {searchTerms.append("USDAFoodSearchTable.fdicID = \($0.fdicID.description)")}
        
        let sT = searchTerms.joined(separator: " OR ")
        
        DispatchQueue(label: "search.serial.queue").async {
            var updatedDailyMealFoods: [DailyMealFoods] = []
            let queryResult = DatabaseQueries.databaseSavedFoodsSearch(searchTerms: sT, databasePointer: databasePointer)
            
            for i in self.dailyMeal.decodeFoodJSON() {
                updatedDailyMealFoods.append(DailyMealFoods(mealFood: i, foodDetails: queryResult.first(where: {$0.fdicID == i.fdicID})))
            }
            
            DispatchQueue.main.async(execute: {
                self.dailyMealFoods = updatedDailyMealFoods
                var totals = DailyMealTotals()
                
                for i in self.dailyMealFoods {
                    if i.foodDetails?.carbs != "N/A" {
                        var aC:  Float  = ((Float(i.foodDetails?.carbs ?? "") ?? 0)*Float(i.mealFood?.customServingPercentage ?? 0))
                        aC = aC + (Float(totals.totalCarbs) ?? 0)
                        totals.totalCarbs = String(format: "%.1f", aC)
                        
                        var aSug:  Float  = ((Float(i.foodDetails?.totalSugars ?? "") ?? 0)*Float(i.mealFood?.customServingPercentage ?? 0))
                        aSug = aSug + (Float(totals.totalSugars) ?? 0)
                        totals.totalSugars = String(format: "%.1f", aSug)
                        
                        var aStarch:  Float  = ((Float(i.foodDetails?.totalStarches ?? "") ?? 0)*Float(i.mealFood?.customServingPercentage ?? 0))
                        aStarch = aStarch + (Float(totals.totalStarches) ?? 0)
                        totals.totalStarches = String(format: "%.1f", aStarch)
                    }
                }
                
                self.dailyMealTotals = totals
            })
        }
    }

    func dailyMealCheck(selectedDay: Date, mealType: String) -> Bool {
        let sD = Temporal.Date.init(selectedDay, timeZone: .none)
        let d = dailyMeals.filter {$0.mealDate?.iso8601FormattedString(format: .short) == sD.iso8601FormattedString(format: .short) }
        
        if (d.first(where: {$0.mealType == mealType}) ?? Meals()).mealType != nil {
            return true
        }
        
        return false
    }
    
    func filterDailyMeal(selectedDay: Date, mealType: String) {
        let sD = Temporal.Date.init(selectedDay, timeZone: .none)
        let d = dailyMeals.filter {$0.mealDate?.iso8601FormattedString(format: .short) == sD.iso8601FormattedString(format: .short) }
        dailyMeal = d.first(where: {$0.mealType == mealType}) ?? Meals()
        
        getMealFoodDetails()
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
