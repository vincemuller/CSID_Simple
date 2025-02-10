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
//    @State private var dailyMeal: Meals = Meals()
//    @State private var dailyMealFoods: [DailyMealFoods] = user.dailyMealFoods
    @State var selectedDay: Date = Date.now
    
    var body: some View {
        ZStack (alignment: .topLeading) {
            BackgroundView()
                .navigationTitle("\(mealType.label) Meal Review")
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
        .onAppear {
//            filterDailyMeal(selectedDay: selectedDay, mealType: mealType.label)
            user.filterDailyMeal(selectedDay: selectedDay, mealType: mealType.label)
        }
    }
    
//    private func getMealFoodDetails() {
//        //Build search terms "USDAFoodSearchTable.fdicID = 2700004"
//        var searchTerms: [String] = []
//        
//        for i in dailyMeal.decodeFoodJSON() {
//            searchTerms.append("USDAFoodSearchTable.fdicID = \(i.fdicID.description)")
//        }
//        
//        let sT = searchTerms.joined(separator: " OR ")
//        
//        DispatchQueue(label: "search.serial.queue").async {
//            var updatedDailyMealFoods: [DailyMealFoods] = []
//            let queryResult = DatabaseQueries.databaseSavedFoodsSearch(searchTerms: sT, databasePointer: databasePointer)
//            print(queryResult)
//            
//            for i in dailyMeal.decodeFoodJSON() {
//                print(i.customServingPercentage.description)
//                updatedDailyMealFoods.append(DailyMealFoods(mealFood: i, foodDetails: queryResult.first(where: {$0.fdicID == i.fdicID})))
//            }
//            DispatchQueue.main.async {
//                self.dailyMealFoods = updatedDailyMealFoods
//            }
//        }
//    }
//    
//    func filterDailyMeal(selectedDay: Date, mealType: String) {
//        let sD = Temporal.Date.init(selectedDay, timeZone: .none)
//        let d = User.shared.dailyMeals.filter {$0.mealDate?.iso8601FormattedString(format: .short) == sD.iso8601FormattedString(format: .short) }
//        dailyMeal = d.first(where: {$0.mealType == mealType}) ?? Meals()
//
//        if dailyMeal.mealType != nil {
//            getMealFoodDetails()
//        }
//    }
}

#Preview {
    MealFoodListScreen(mealType: .afternoonSnack)
}
