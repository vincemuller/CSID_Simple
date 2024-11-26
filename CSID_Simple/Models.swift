//
//  Models.swift
//  CSID_Simple
//
//  Created by Vince Muller on 11/2/24.
//

import Foundation

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

