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

    private init(userID: String? = "vmuller2529", userSavedLists: [SavedLists] = [], userSavedFoods: [SavedFoods] = []) {
        self.userID = userID
        self.userSavedLists = userSavedLists
        self.userSavedFoods = userSavedFoods
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
