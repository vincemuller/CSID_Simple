//
//  MealFoodListScreen.swift
//  CSID_Simple
//
//  Created by Vince Muller on 2/8/25.
//

import SwiftUI
import Amplify


struct MealFoodListScreen: View {
    @EnvironmentObject var user: User
    
    var mealType: MealType
    
    @State var selectedDay: Date

    
    var body: some View {
        ZStack (alignment: .topLeading) {
            BackgroundView()
                .navigationTitle("\(mealType.label) Meal Review")
            VStack {
                Text("Total carbs: \(user.dailyMealTotals.totalCarbs)")
                Text("Total sugars: \(user.dailyMealTotals.totalSugars)")
                Text("Total starches: \(user.dailyMealTotals.totalStarches)")
                ScrollView {
                    LazyVGrid (columns: [GridItem(.flexible())], spacing: 10) {
                        ForEach(user.dailyMealFoods, id: \.id) {food in
                            let brand = food.foodDetails?.wholeFood.lowercased() == "yes" ? "Whole Food" : food.foodDetails?.brandName?.brandFormater(brandOwner: food.foodDetails?.brandOwner ?? "")
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.textField)
                                    .frame(width: 360)
                                HStack {
                                    VStack (alignment: .leading) {
                                        StandardTextView(label: brand ?? "", size: 12, textColor: .iconTeal)
                                        StandardTextView(label: food.foodDetails?.description ?? "", size: 16, weight: .semibold)
                                        Spacer()
                                        HStack {
                                            StandardTextView(label: "Servings: \(food.mealFood?.customServingPercentage.description ?? "")", size: 12)
                                                .frame(width: 100, alignment: .leading)
                                            Spacer()
                                            StandardTextView(label: "Sugars: \(food.foodDetails?.totalSugars ?? "")", size: 12)
                                                .frame(width: 100, alignment: .leading)
                                            StandardTextView(label: "Starches: \(food.foodDetails?.totalStarches ?? "")", size: 12)
                                                .frame(width: 100, alignment: .leading)
                                            Spacer()
                                        }.padding(.top, 7)
                                    }
                                    Spacer()
                                }.padding(.vertical, 7).padding(.leading)
                            }.frame(width: 360)
                        }
                        NavigationLink(destination: FindMealFoodsScreen(mealType: mealType, selectedDay: selectedDay)) {
                            HStack {
                                Image(systemName: "plus")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(.iconTeal)
                                Text("Add More Foods")
                                    .font(.system(size: 16))
                                    .foregroundStyle(.iconTeal)
                            }
                            .frame(width: 360, height: 30, alignment: .leading)
                            .padding(.leading)
                        }
                    }
                }.padding(.vertical)
            }
        }
        .onAppear {
            user.filterDailyMeal(selectedDay: selectedDay, mealType: mealType.label)
        }
    }
}

#Preview {
    MealFoodListScreen(mealType: .afternoonSnack, selectedDay: Date())
}
