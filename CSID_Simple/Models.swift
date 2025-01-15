//
//  Models.swift
//  CSID_Simple
//
//  Created by Vince Muller on 11/2/24.
//

import Foundation
import Charts

struct FoodDetails: Codable, Hashable, Identifiable {
    var id = UUID()
    var searchKeyWords:         String
    var fdicID:                 Int
    var brandOwner:             String?
    var brandName:              String?
    var brandedFoodCategory:    String
    var description:            String
    var servingSize:            Float
    var servingSizeUnit:        String
    var carbs:                  String
    var totalSugars:            String
    var totalStarches:          String
    var wholeFood:              String
}

struct NutrientData: Codable, Identifiable {
    var id = UUID()
    var carbs:                  String
    var fiber:                  String
    var netCarbs:               String
    var totalSugars:            String
    var totalStarches:          String
    var totalSugarAlcohols:     String
    var protein:                String
    var totalFat:               String
    var sodium:                 String
    var ingredients:            String
}

struct TolerationChunks: Identifiable {
    var id = UUID()
    var canNotTolerate: [TolerationRating]
    var tolerateWithStipulations: [TolerationRating]
    var canTolerate: [TolerationRating]
}

struct Meal: Codable {
    var foods: [MealFood]
    
    func getMealJSON() -> String {
        var encodeStringMeal: String = ""
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted

        do {
            let encodeMeal = try jsonEncoder.encode(self.foods)
            encodeStringMeal = String(data: encodeMeal, encoding: .utf8)!
        } catch {
            print(error.localizedDescription)
        }
        
        return encodeStringMeal
    }
}

struct MealFood: Codable {
    var fdicID: Int
    var customServingPercentage: Float
}

