//
//  ViewModel.swift
//  CSID_Simple
//
//  Created by Vince Muller on 11/6/24.
//

import Foundation

final class ViewModel: ObservableObject {
    @Published var compareFoodsSheetPresenting: Bool = false
    @Published var selectedFood: FoodDetails = FoodDetails(searchKeyWords: "", fdicID: 0, brandedFoodCategory: "", description: "", servingSize: 0, servingSizeUnit: "", carbs: "", totalSugars: "", totalStarches: "", wholeFood: "")
    @Published var compareQueue: [FoodDetails] = []
    @Published var comparisonNutData: [NutrientData] = []
    @Published var foodDetalsPresenting: Bool = false
}
