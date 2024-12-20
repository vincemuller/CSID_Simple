//
//  PersistanceManager.swift
//
//  Created by Vince Muller on 11/23/2024.
//


import Foundation


enum PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let userSession = "userSession"
    }
    
    static func retrieveUserSession(completed: @escaping (Result<String, Error>) -> Void) {
        guard let sessionData = defaults.object(forKey: Keys.userSession) as? Data else {
            completed(.success("n/a"))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let session = try decoder.decode(String.self, from: sessionData)
            completed(.success(session))
        } catch {
            print("Unable to retrieve session, check persistence manager")
            completed(.failure(error))
        }
    }
    
    static func logIn(userID: String) -> Error? {
        do {
            let encoder = JSONEncoder()
            let encodedUser = try encoder.encode(userID)
            defaults.set(encodedUser, forKey: Keys.userSession)
            return nil
        } catch {
            print("Unable to log user data logIn func in PersistenceManager")
            return error
        }
    }
    
    static func logOut() {
        defaults.removeObject(forKey: Keys.userSession)
        print("Log Out successful")
    }

    
}
