//
//  FoodDetailsScreen.swift
//  CSID_Simple
//
//  Created by Vince Muller on 11/5/24.
//

import SwiftUI

struct FoodDetailsScreen: View {
    
    var food: FoodDetails
    
    var body: some View {
        ZStack (alignment: .top) {
            BackgroundView()
            HStack {
                Text(food.description)
            }
        }
    }
}

#Preview {
    FoodDetailsScreen(food: FoodDetails(searchKeyWords: "", fdicID: 10001, brandOwner: "M&M Mars", brandName: "Snickers", brandedFoodCategory: "Confectionary and Sweets", description: "Snickers Crunchers, Chocolate Bar", servingSize: 12, servingSizeUnit: "g", carbs: "25", totalSugars: "18", totalStarches: "7", wholeFood: "no"))
}
