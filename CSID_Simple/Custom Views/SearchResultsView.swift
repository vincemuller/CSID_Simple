//
//  SearchResultsView.swift
//  CSID_Simple
//
//  Created by Vince Muller on 11/3/24.
//

import SwiftUI

struct SearchResultsView: View {
    
    @Binding var isPresenting: Bool
    @Binding var selectedFood: FoodDetails
    @Binding var compareQueue: [FoodDetails]
    @Binding var searchResults: [FoodDetails]
    @State var selectedSort: String
    
    var savedFoods: [Int] = []
    
    var body: some View {
        ScrollView {
            LazyVGrid (columns: [GridItem(.flexible())], spacing: 5) {
                ForEach(searchResults, id: \.self) {food in
                    SearchResultCellView(isPresenting: $isPresenting, selectedFood: $selectedFood, compareQueue: $compareQueue, result: food, isFavorite: savedFoods.contains(food.fdicID), selectedSort: selectedSort)
                }.padding(.bottom, 5)
            }
        }
    }
    
}

#Preview {
    SearchResultsView(isPresenting: .constant(false), selectedFood: .constant(FoodDetails(searchKeyWords: "", fdicID: 0, brandedFoodCategory: "", description: "", servingSize: 0, servingSizeUnit: "", carbs: "", totalSugars: "", totalStarches: "", wholeFood: "")), compareQueue: .constant([]), searchResults: .constant([]), selectedSort: "Relevance")
}
