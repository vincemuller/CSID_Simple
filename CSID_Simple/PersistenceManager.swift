//
//  PersistanceManager.swift
//  CSID_App
//
//  Created by Vince Muller on 3/10/24.
//

import Foundation

enum FavoriteActionType {
    case add, remove
}

enum CreateActionType {
    case create, modify, delete
}

enum PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let favorites = "favorites"
        static let userFoods = "userFoods"
    }
    
    static func retrieveFavorites(completed: @escaping (Result<[USDAFoodDetails], Error>) -> Void) {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([USDAFoodDetails].self, from: favoritesData)
            completed(.success(favorites))
        } catch {
            print("Unable to favorite!, check PersistenceManager")
            completed(.failure(error))
        }
    }
    
    static func getUserFavs() -> [USDAFoodDetails] {
        var userFavs: [USDAFoodDetails] = []
        PersistenceManager.retrieveFavorites { result in
            switch result {
            case .success(let favorites):
                userFavs = favorites
            case .failure(let error):
                print(error)
            }
        }
        return userFavs
    }
}
