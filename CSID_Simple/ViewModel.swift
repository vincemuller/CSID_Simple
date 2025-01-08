//
//  ViewModel.swift
//  CSID_Simple
//
//  Created by Vince Muller on 11/6/24.
//

import Foundation
import Amplify
import AWSPluginsCore
import AWSAPIPlugin

final class ViewModel: ObservableObject {
    @Published var compareFoodsSheetPresenting: Bool = false
    @Published var selectedFood: FoodDetails = FoodDetails(searchKeyWords: "", fdicID: 0, brandedFoodCategory: "", description: "", servingSize: 0, servingSizeUnit: "", carbs: "", totalSugars: "", totalStarches: "", wholeFood: "")
    @Published var compareQueue: [FoodDetails] = []
    @Published var comparisonNutData: [NutrientData] = []
    @Published var foodDetalsPresenting: Bool = false
    @Published var createListScreenPresenting: Bool = false
    
    
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
