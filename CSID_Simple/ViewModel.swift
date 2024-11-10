//
//  ViewModel.swift
//  CSID_Simple
//
//  Created by Vince Muller on 11/6/24.
//

import Foundation

@MainActor final class ViewModel: ObservableObject {
    @Published var foodDetalsPresenting: Bool = false
    @Published var selectedFood: FoodDetails = FoodDetails(searchKeyWords: "", fdicID: 0, brandedFoodCategory: "", description: "", servingSize: 0, servingSizeUnit: "", carbs: "", totalSugars: "", totalStarches: "", wholeFood: "")
    @Published var compareQueue: [FoodDetails] = []
}
