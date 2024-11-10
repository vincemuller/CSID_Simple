//
//  ComparisonScreen.swift
//  CSID_Simple
//
//  Created by Vince Muller on 11/8/24.
//

import SwiftUI

struct ComparisonScreen: View {
    
    var foods: [FoodDetails] = [FoodDetails(searchKeyWords: "", fdicID: 100, brandOwner: "M&M Mars", brandName: "Snickers", brandedFoodCategory: "Confectionary and Sweets", description: "Snickers Crunchers, Chocolate Bar, Snickers Crunchers, Chocolate Bar, Snickers Crunchers, Chocolate Bar, Snickers Crunchers, Chocolate Bar, Snickers Crunchers, Chocolate Bar", servingSize: 28, servingSizeUnit: "g", carbs: "25", totalSugars: "12.5", totalStarches: "12.5", wholeFood: "no"),FoodDetails(searchKeyWords: "", fdicID: 200, brandOwner: "M&M Mars", brandName: "Snickers", brandedFoodCategory: "Confectionary and Sweets", description: "Snickers Crunchers, Chocolate Bar", servingSize: 28, servingSizeUnit: "g", carbs: "25", totalSugars: "12.5", totalStarches: "12.5", wholeFood: "no")]
    
    @State var nutrition: [NutrientData] = []
//    var foods: [FoodDetails] = []
    
    var body: some View {
        ZStack (alignment: .top) {
            BackgroundView()
            VStack {
                Grid {
                    GridRow {
                        ForEach(foods) { food in
                            GeometryReader(content: { geometry in
                                ScrollView {
                                    Text(food.description)
                                        .font(.system(size: 12))
                                        .lineLimit(nil)
                                        .multilineTextAlignment(.center)
                                        .frame(width: geometry.size.width)
                                }
                            }).frame(height: 60)
                        }
                    }
                    Divider()
                    Text("Total Carbs")
                        .font(.system(size: 8))
                    GridRow {
                        ForEach(foods) { food in
                            Text(food.carbs)
                        }
                    }
                    Divider()
                    Text("Fiber")
                        .font(.system(size: 8))
                    GridRow {
                        ForEach(nutrition) { food in
                            Text(food.fiber)
                        }
                    }
                    Divider()
                    Text("Net Carbs")
                        .font(.system(size: 8))
                    GridRow {
                        ForEach(foods) { food in
                            Text(food.carbs)
                        }
                    }
                    Divider()
                    Text("Total Sugars")
                        .font(.system(size: 8))
                    GridRow {
                        ForEach(foods) { food in
                            Text(food.totalSugars)
                        }
                    }
                    Divider()
                    Text("Total Starches")
                        .font(.system(size: 8))
                    GridRow {
                        ForEach(foods) { food in
                            Text(food.totalStarches)
                        }
                    }
                    Divider()
                    Text("Serving Size")
                        .font(.system(size: 8))
                    GridRow {
                        ForEach(foods) { food in
                            Text("\(food.servingSize.formatted())\(food.servingSizeUnit)")
                        }
                    }
                    Divider()
                    Text("Ingredients")
                        .font(.system(size: 8))
                    GridRow {
                        ForEach(nutrition) { food in
                            GeometryReader(content: { geometry in
                                ScrollView {
                                    Text(food.ingredients)
                                        .font(.system(size: 9))
                                        .lineLimit(nil)
                                        .multilineTextAlignment(.center)
                                        .frame(width: geometry.size.width-10)
                                }
                            }).frame(height: 300)
                        }
                    }
                }.padding()
            }.frame(width: 360, alignment: .top).background(RoundedRectangle(cornerRadius: 20).fill(.textField)).offset(y: 60)
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    ComparisonScreen()
}
