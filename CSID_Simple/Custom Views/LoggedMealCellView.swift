//
//  LoggedMealView.swift
//  CSID_Simple
//
//  Created by Vince Muller on 1/24/25.
//

import SwiftUI
import Amplify

struct LoggedMealCellView: View {
    
    var meal: Meals
    
    var body: some View {
        ZStack (alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 12)
                .fill(.textField)
            VStack (alignment: .leading, spacing: 0) {
                HStack {
                    Text(meal.mealType ?? "")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.iconTeal)
                        .lineLimit(1)
                        .offset(y: 1)
                    Spacer()
                    switch meal.tolerationRating {
                    case "0":
                        Circle()
                            .fill(.red)
                            .frame(width: 13)
                    case "1":
                        Circle()
                            .fill(.yellow)
                            .frame(width: 13)
                    case "2":
                        Circle()
                            .fill(.green)
                            .frame(width: 13)
                    default:
                        Text("")
                    }
                }
                Text(meal.mealName ?? "")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .minimumScaleFactor(0.75)
                    .frame(width: 245, height: 50, alignment: .topLeading)
                    .offset(y: 5)
                Rectangle()
                    .fill(.white.opacity(0.3))
                    .frame(height: 2)
                HStack (spacing: 30) {
                    VStack (spacing: 10) {
                        ZStack {
                            Circle()
                                .stroke(.iconRed, lineWidth: 3)
                            Text("25g")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                        Text("Total Sugars")
                            .foregroundStyle(.white)
                            .font(.system(size: 12, weight: .semibold))
                    }
                    VStack (spacing: 10) {
                        ZStack {
                            Circle()
                                .stroke(.iconTeal, lineWidth: 3)
                            Text("25g")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                        Text("Total Carbs")
                            .foregroundStyle(.white)
                            .font(.system(size: 12, weight: .semibold))
                    }
                    VStack (spacing: 10) {
                        ZStack {
                            Circle()
                                .stroke(.iconOrange, lineWidth: 3)
                            Text("25g")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                        Text("Total Starches")
                            .foregroundStyle(.white)
                            .font(.system(size: 12, weight: .semibold))
                    }
                }.frame(width: 330).offset(y: 15)
                Spacer()
            }
            .padding()
        }
        .frame(width: 360, height: 200)
    }
}

#Preview {
    let foods = Meal(foods: [MealFood(fdicID: 2700005, customServingPercentage: 0.5),MealFood(fdicID: 1457369, customServingPercentage: 0.5)])
    
    LoggedMealCellView(meal: Meals(id: UUID().uuidString, userID: "vmuller2529", mealType: MealType.afternoonSnack.label, mealName: "Apples and Chips Apples and Chips Apples and Chips Apples and Chips ", foods: foods.getMealJSON(), additionalNotes: "This snack hurt my stomach and gave me gas", tolerationRating: "0", createdAt: Temporal.DateTime.now(), updatedAt: Temporal.DateTime.now()))
}
