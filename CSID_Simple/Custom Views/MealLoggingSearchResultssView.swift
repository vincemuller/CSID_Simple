//
//  MealLoggingSearchResultView.swift
//  CSID_Simple
//
//  Created by Vince Muller on 2/1/25.
//

import SwiftUI

struct MealLoggingSearchResultssView: View {
    
    @Binding var isPresenting: Bool
    @Binding var logServingSizeSheetIsPresenting: Bool
    @Binding var selectedFood: FoodDetails
    @Binding var searchResults: [FoodDetails]
    @State var selectedSort: String
    
    var savedFoods: [Int] = []
    
    var body: some View {
        ScrollView {
            LazyVGrid (columns: [GridItem(.flexible())], spacing: 5) {
                ForEach(searchResults, id: \.self) {food in
                    SearchResultCellView(searchResultCellType: .mealFoods, logServingSizeSheetIsPresenting: $logServingSizeSheetIsPresenting, isPresenting: $isPresenting, selectedFood: $selectedFood, compareQueue: .constant([]), result: food)
                }.padding(.bottom, 5)
            }
        }
    }
}

#Preview {
    MealLoggingSearchResultssView(isPresenting: .constant(false), logServingSizeSheetIsPresenting: .constant(false), selectedFood: .constant(FoodDetails(searchKeyWords: "", fdicID: 0, brandedFoodCategory: "", description: "", servingSize: 0, servingSizeUnit: "", carbs: "", totalSugars: "", totalStarches: "", wholeFood: "")), searchResults: .constant([]), selectedSort: "")
}
