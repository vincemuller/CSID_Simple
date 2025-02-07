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

@Observable
class User {
    static let shared = User()
    
    var userID: String?
    var userSavedLists: [SavedLists]
    var userSavedFoods: [SavedFoods]
    var dailyMeals: List<Meals>
    

    private init(userID: String? = "vmuller2529", userSavedLists: [SavedLists] = [], userSavedFoods: [SavedFoods] = [], dailyMeals: List<Meals> = []) {
        self.userID = userID
        self.userSavedLists = userSavedLists
        self.userSavedFoods = userSavedFoods
        self.dailyMeals = dailyMeals
    }
    

    func mealLogging(meal: Meal) async {
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
    
    func getDailyMeals(selectedDay: Date) async {
        let d = Temporal.Date.init(selectedDay.addingTimeInterval(.days(-7)), timeZone: .autoupdatingCurrent)
        let meals = Meals.keys
        let predicate = meals.userID == User.shared.userID && meals.mealDate > d && meals.mealDate <= Temporal.Date.init(selectedDay.addingTimeInterval(.days(6)), timeZone: .autoupdatingCurrent)
        let request = GraphQLRequest<Meals>.list(Meals.self, where: predicate)
        do {
            let result = try await Amplify.API.query(request: request)
            switch result {
            case .success(let meals):
                print("Successfully retrieved meals: \(meals.count)")
                
                dailyMeals = meals
                
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
    
    func getSavedLists() async {
        let lists = SavedLists.keys
        let predicate = lists.userID == User.shared.userID
        let request = GraphQLRequest<SavedLists>.list(SavedLists.self, where: predicate)
        do {
            let result = try await Amplify.API.query(request: request)
            switch result {
            case .success(let lists):
                print("Successfully retrieved saved lists: \(lists.count)")
                DispatchQueue.main.async {
                    User.shared.userSavedLists.removeAll()
                }
                for l in lists {
                    DispatchQueue.main.async {
                        User.shared.userSavedLists.append(l)
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
        let predicate = foods.userID == User.shared.userID
        let request = GraphQLRequest<SavedFoods>.list(SavedFoods.self, where: predicate)
        do {
            let result = try await Amplify.API.query(request: request)
            switch result {
            case .success(let foods):
                print("Successfully retrieved saved foods: \(foods.count)")
                DispatchQueue.main.async {
                    User.shared.userSavedFoods.removeAll()
                }
                for l in foods {
                    DispatchQueue.main.async {
                        User.shared.userSavedFoods.append(l)
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
