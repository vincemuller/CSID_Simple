//
//  Models.swift
//  CSID_Simple
//
//  Created by Vince Muller on 11/2/24.
//

import Foundation

struct FoodDetails: Codable, Hashable {
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
