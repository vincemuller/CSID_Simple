//
//  FoodDetailsScreen.swift
//  CSID_Simple
//
//  Created by Vince Muller on 11/5/24.
//

import SwiftUI

struct FoodDetailsScreen: View {
    
    @State var nutrition: NutrientData?
    @State private var isFavorite: Bool = true
    @State private var customServing: String = ""
    
    @State var food: FoodDetails
    
    var body: some View {
        ZStack (alignment: .topLeading) {
            BackgroundView()
            VStack {
                HStack {
                    Text(food.description)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .lineLimit(5)
                        .minimumScaleFactor(0.7)
                        .frame(width: 320, height: 80, alignment: .bottomLeading)
                    Image(systemName: "bookmark.fill")
                        .font(.system(size: 30))
                        .foregroundStyle(.iconTeal)
                        .frame(height: 80, alignment: .bottom)
                        .offset(y: 15)
                }
                Text(food.brandedFoodCategory)
                    .font(.system(size: 12))
                    .foregroundStyle(Color(UIColor.label).opacity(0.6))
                    .frame(width: 358, alignment: .leading)
                ZStack (alignment: .center) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.textField)
                        .frame(width: 365, height: 60)
                        .offset(y: 5)
                    VStack (alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Brand Owner:")
                                .font(.system(size: 12, weight: .semibold))
                                .padding(.leading, 10)
                            Text(food.brandOwner ?? "")
                                .font(.system(size: 12))
                        }
                        HStack {
                            Text("Brand Name:")
                                .font(.system(size: 12, weight: .semibold))
                                .padding(.leading, 10)
                            Text(food.brandName ?? "")
                                .font(.system(size: 12))
                        }
                    }
                    .frame(width: 365, height: 50, alignment: .leading)
                    .offset(y: 3)
                }
                HStack {
                    ZStack (alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.textField)
                        HStack (alignment: .center) {
                            Text("Serving Size:")
                                .font(.system(size: 14, weight: .semibold))
                                .padding(.leading, 10)
                            Text("\(food.servingSize)\(food.servingSizeUnit)")
                                .font(.system(size: 14))
                        }
                    }.frame(width: 230, height: 50)
                    TextField("Custom Serving", text: $customServing)
                        .font(.system(size: 14, weight: .semibold))
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .frame(height: 50)
                        .keyboardType(.numberPad)
                        .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.textField)
                            )
                }
                .frame(width: 365, height: 50, alignment: .leading)
                .offset(y: 5)
            }.padding()
        }
    }
}

#Preview {
    FoodDetailsScreen(food: FoodDetails(searchKeyWords: "", fdicID: 10001, brandOwner: "M&M Mars", brandName: "Snickers", brandedFoodCategory: "Confectionary and Sweets", description: "S'mores Marsh mallow Sauce", servingSize: 12, servingSizeUnit: "g", carbs: "25", totalSugars: "18", totalStarches: "7", wholeFood: "no"))
}
