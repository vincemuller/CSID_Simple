//
//  LoggedMealsScreen.swift
//  CSID_Simple
//
//  Created by Vince Muller on 1/24/25.
//

import SwiftUI
import Amplify

struct LoggedMealsScreen: View {
    
    @State var mealType: MealType
    @State var meals: [Meals] = [Meals(id: UUID().uuidString, userID: "vmuller2529", mealType: MealType.afternoonSnack.label, mealName: "Apples and Chips", foods: Meal(foods: [MealFood(fdicID: 2700005, customServingPercentage: 0.5),MealFood(fdicID: 1457369, customServingPercentage: 0.5)]).getMealJSON(), additionalNotes: "This snack hurt my stomach and gave me gas", tolerationRating: "0", createdAt: Temporal.DateTime.now(), updatedAt: Temporal.DateTime.now()),Meals(id: UUID().uuidString, userID: "vmuller2529", mealType: MealType.afternoonSnack.label, mealName: "Yogurt and Granola", foods: Meal(foods: [MealFood(fdicID: 2700005, customServingPercentage: 0.5),MealFood(fdicID: 1457369, customServingPercentage: 0.5)]).getMealJSON(), additionalNotes: "This snack was delicious and I could tolerate it", tolerationRating: "2", createdAt: Temporal.DateTime.now(), updatedAt: Temporal.DateTime.now())]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                BackgroundView()
                VStack (alignment: .leading, spacing: 15) {
                    Text(mealType.label.lowercased().contains("snack") ? "\(mealType.label)s" : "\(mealType.label) Meals")
                        .font(.system(size: 30, weight: .semibold))
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding()
                    ScrollView {
                        VStack (alignment: .center, spacing: 15) {
                            ForEach(meals, id: \.id) { meal in
                                LoggedMealCellView(meal: meal)
                            }
                        }
                    }
                    .frame(width: geometry.size.width)
                }
            }
        }
    }
}

#Preview {
    let foods = Meal(foods: [MealFood(fdicID: 2700005, customServingPercentage: 0.5),MealFood(fdicID: 1457369, customServingPercentage: 0.5)])
    
    LoggedMealsScreen(mealType: MealType.afternoonSnack, meals: [Meals(id: UUID().uuidString, userID: "vmuller2529", mealType: MealType.afternoonSnack.label, mealName: "Apples and Chips", foods: foods.getMealJSON(), additionalNotes: "This snack hurt my stomach and gave me gas", tolerationRating: "0", createdAt: Temporal.DateTime.now(), updatedAt: Temporal.DateTime.now()),Meals(id: UUID().uuidString, userID: "vmuller2529", mealType: MealType.afternoonSnack.label, mealName: "Yogurt and Granola", foods: foods.getMealJSON(), additionalNotes: "This snack was delicious and I could tolerate it", tolerationRating: "2", createdAt: Temporal.DateTime.now(), updatedAt: Temporal.DateTime.now())])
}
