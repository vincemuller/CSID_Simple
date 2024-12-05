//
//  ComparisonScreen.swift
//  CSID_Simple
//
//  Created by Vince Muller on 11/8/24.
//

import SwiftUI

struct ComparisonScreen: View {
    
    var foods: [FoodDetails] = [FoodDetails(searchKeyWords: "", fdicID: 100, brandOwner: "M&M Mars", brandName: "Snickers, asdfasdf, asdfasdf, asdfasdf, asdfasdf", brandedFoodCategory: "Confectionary and Sweets", description: "Snickers Crunchers, Chocolate Bar, Snickers Crunchers, Chocolate Bar, Snickers Crunchers, Chocolate Bar, Snickers Crunchers, Chocolate Bar, Snickers Crunchers, Chocolate Bar", servingSize: 28, servingSizeUnit: "g", carbs: "25", totalSugars: "12.5", totalStarches: "12.5", wholeFood: "no"),FoodDetails(searchKeyWords: "", fdicID: 200, brandOwner: "M&M Mars", brandName: "Snickers", brandedFoodCategory: "Confectionary and Sweets", description: "Snickers Crunchers, Chocolate Bar, Snickers Crunchers, Chocolate Bar, Snickers Crunchers, Chocolate Bar, Snickers Crunchers, Chocolate Bar, Snickers Crunchers, Chocolate Bar", servingSize: 28, servingSizeUnit: "g", carbs: "25", totalSugars: "12.5", totalStarches: "12.5", wholeFood: "no")]
    
    @Binding var nutrition: [NutrientData]
    @State var adjustedNutrition: [NutrientData] = []
    @State private var ingredientsExpand = false
    @State private var customServingExpand = false
    @State private var customServing: String = ""
    
    var helper = Helpers()
    
    var body: some View {
        let brand = [foods[0].wholeFood == "yes" ? "Whole Food" : foods[0].brandName?.brandFormater(brandOwner: foods[0].brandOwner ?? ""),
                     foods[1].wholeFood == "yes" ? "Whole Food" : foods[1].brandName?.brandFormater(brandOwner: foods[1].brandOwner ?? "")]
        
        ZStack (alignment: .top) {
            BackgroundView()
            VStack (spacing: 15) {
                    Text("Nutritional Comparison")
                        .foregroundStyle(.white)
                        .font(.title)
                        .padding(.top, 10)
                VStack {
                    Grid (horizontalSpacing: 35) {
                        GridRow {
                            ForEach(brand, id: \.self) { brand in
                                GeometryReader(content: { geometry in
                                    ScrollView {
                                        Text(brand ?? "N/A")
                                            .font(.system(size: 10))
                                            .foregroundStyle(.iconTeal)
                                            .lineLimit(nil)
                                            .multilineTextAlignment(.center)
                                            .frame(width: geometry.size.width)
                                        
                                        // Set the content’s min height to the parent
                                            .frame(minHeight: geometry.size.height)
                                    }
                                }).frame(height: 25).padding(.bottom, 5)
                            }
                        }
                        Divider()
                        GridRow {
                            ForEach(foods) { food in
                                GeometryReader(content: { geometry in
                                    ScrollView {
                                        Text(food.description)
                                            .foregroundStyle(.white)
                                            .font(.system(size: 12))
                                            .lineLimit(nil)
                                            .multilineTextAlignment(.center)
                                            .frame(width: geometry.size.width)
                                        
                                        // Set the content’s min height to the parent
                                            .frame(minHeight: geometry.size.height)
                                    }
                                }).frame(height: 60).padding(.bottom, 5)
                            }
                        }
                        Divider()
                        Text("Total Carbs")
                            .foregroundStyle(.white)
                            .font(.system(size: 12))
                        GridRow {
                            ForEach(adjustedNutrition.isEmpty ? nutrition : adjustedNutrition) { food in
                                Text("\(food.carbs)g")
                                    .foregroundStyle(.white)
                            }
                        }
                        Divider()
                        Text("Fiber")
                            .foregroundStyle(.white)
                            .font(.system(size: 12))
                        GridRow {
                            ForEach(adjustedNutrition.isEmpty ? nutrition : adjustedNutrition) { food in
                                Text("\(food.fiber)g")
                                    .foregroundStyle(.white)
                            }
                        }
                        Divider()
                        Text("Net Carbs")
                            .foregroundStyle(.white)
                            .font(.system(size: 12))
                        GridRow {
                            ForEach(adjustedNutrition.isEmpty ? nutrition : adjustedNutrition) { food in
                                Text("\(food.carbs)g")
                                    .foregroundStyle(.white)
                            }
                        }
                        Divider()
                        Text("Total Sugars")
                            .foregroundStyle(.white)
                            .font(.system(size: 12))
                        GridRow {
                            ForEach(adjustedNutrition.isEmpty ? nutrition : adjustedNutrition) { food in
                                Text("\(food.totalSugars)g")
                                    .foregroundStyle(.white)
                            }
                        }
                        Divider()
                        Text("Total Starches")
                            .foregroundStyle(.white)
                            .font(.system(size: 12))
                        GridRow {
                            ForEach(adjustedNutrition.isEmpty ? nutrition : adjustedNutrition) { food in
                                Text("\(food.totalStarches)g")
                                    .foregroundStyle(.white)
                            }
                        }
                        Divider()
                        Text("Serving Size")
                            .foregroundStyle(.white)
                            .font(.system(size: 12))
                        GridRow {
                            ForEach(foods) { food in
                                Text("\(food.servingSize.formatted())\(food.servingSizeUnit)")
                                    .foregroundStyle(.white)
                            }
                        }
                            TextField("Custom Serving", text: $customServing)
                                .foregroundStyle(.white)
                                .font(.system(size: 12, weight: .semibold))
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .frame(width: 110, height: 30)
                                .keyboardType(.decimalPad)
                                .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.white.opacity(0.4))
                                    )
                                .offset(y: -10)
                        Divider()
                        Text("Ingredients")
                            .foregroundStyle(.white)
                            .font(.system(size: 12))
                        Image(systemName: ingredientsExpand ? "chevron.up" : "chevron.down")
                            .foregroundStyle(.white)
                            .padding(.top, 5)
                            .onTapGesture {
                                ingredientsExpand.toggle()
                            }
                        !ingredientsExpand ? nil : GridRow {
                            ForEach(nutrition) { food in
                                GeometryReader(content: { geometry in
                                    ScrollView {
                                        Text(food.ingredients)
                                            .foregroundStyle(.white)
                                            .font(.system(size: 12))
                                            .lineLimit(nil)
                                            .multilineTextAlignment(.center)
                                            .frame(width: geometry.size.width)
                                    }.frame(height: 150)
                                }).frame(height: 160)
                            }
                        }
                    }.padding()
                }.frame(width: 360, alignment: .top).background(RoundedRectangle(cornerRadius: 20).fill(.textField))
            }
            .onChange(of: customServing) {
                adjustedNutrition = []
                
                guard !customServing.isEmpty else {
                    return
                }
                
                adjustedNutrition.append(helper.customServingCalculator(actualServingSize: foods[0].servingSize, customServing: customServing, nutrientData: nutrition[0]))
                adjustedNutrition.append(helper.customServingCalculator(actualServingSize: foods[1].servingSize, customServing: customServing, nutrientData: nutrition[1]))
            }
            .onTapGesture {
                hideKeyBoard()
            }
        }
    }
    
}

#Preview {
    ComparisonScreen(nutrition: .constant([NutrientData(id: UUID(), carbs: "25", fiber: "2", netCarbs: "23", totalSugars: "12.5", totalStarches: "10.5", totalSugarAlcohols: "0", protein: "0", totalFat: "0", sodium: "0", ingredients: "Sugar, Tapioca Starch, Water, Milk, Xantham Gum, Apples"),NutrientData(id: UUID(), carbs: "25", fiber: "2", netCarbs: "23", totalSugars: "12.5", totalStarches: "10.5", totalSugarAlcohols: "0", protein: "0", totalFat: "0", sodium: "0", ingredients: "Sugar, Tapioca Starch, Water, Milk, Xantham Gum, Apples, Sugar, Tapioca Starch, Water, Milk, Xantham Gum, Apples, Sugar, Tapioca Starch, Water, Milk, Xantham Gum, Apples, Sugar, Tapioca Starch, Water, Milk, Xantham Gum, Apples, Sugar, Tapioca Starch, Water, Milk, Xantham Gum, Apples, Sugar, Tapioca Starch, Water, Milk, Xantham Gum, Apples, Sugar, Tapioca Starch, Water, Milk, Xantham Gum, Apples, Sugar, Tapioca Starch, Water, Milk, Xantham Gum, Apples, Sugar, Tapioca Starch, Water, Milk, Xantham Gum, Apples, Sugar, Tapioca Starch, Water, Milk, Xantham Gum, Apples,Sugar, Tapioca Starch, Water, Milk, Xantham Gum, Apples, Water, Milk, Xantham Gum, Apples,Sugar, Tapioca Starch, Water, Milk, Xantham Gum, Apples, Water, Milk, Xantham Gum, Apples,Sugar, Tapioca Starch, Water, Milk, Xantham Gum, Apples")]))
}
