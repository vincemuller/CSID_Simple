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
    
    @State private var editFoodSheetIsPresenting: Bool = false
    @State private var selectedFood: MealFood = MealFood(fdicID: 0, description: "", consumedServings: 0, totalCarbs: "", totalFiber: "", netCarbs: "", totalSugars: "", totalStarches: "", wholeFood: "")
    @State private var customServingPercentage: String = ""
    @State var totalCarbs: String = ""
    @State var netCarbs: String = ""
    @State var totalSugars: String = ""
    @State var totalStarches: String = ""
    @State var mealFoodEditSelection: String = ""
    @State var notificationAlert: Bool = false
    
    
    var body: some View {
        ZStack (alignment: .topLeading) {
            BackgroundView()
                .navigationTitle(user.selectedDay.formatted(.dateTime.month().day().year()))
                .navigationBarItems(trailing:
                    Text("Edit").onTapGesture(perform: {
                    //                    editListScreenPresenting = true
                }))
                .navigationBarTitleDisplayMode(.inline)
            ScrollView {
                VStack {
                    HStack {
                        StandardTextView(label: mealType.label, size: 30, weight: .bold)
                        Spacer()
                    }.padding(.horizontal)
                HStack (spacing: 30) {
                    VStack (spacing: 5) {
                        ZStack {
                            Circle()
                                .stroke(.iconRed, lineWidth: 5)
                                .frame(width: 60, height: 60)
                            StandardTextView(label: "\(totalSugars)g", size: 14)
                        }
                        StandardTextView(label: "Sugars", size: 12).offset(y: 5)
                    }
                    VStack (spacing: 5) {
                        ZStack {
                            Circle()
                                .stroke(.iconTeal, lineWidth: 5)
                                .frame(width: 60, height: 60)
                            StandardTextView(label: "\(totalCarbs)g", size: 14)
                        }
                        StandardTextView(label: "Total Carbs", size: 12).offset(y: 5)
                    }
                    VStack (spacing: 5) {
                        ZStack {
                            Circle()
                                .stroke(.iconBlue, lineWidth: 5)
                                .frame(width: 60, height: 60)
                            StandardTextView(label: "\(netCarbs)g", size: 14)
                        }
                        StandardTextView(label: "Net Carbs", size: 12).offset(y: 5)
                    }
                    VStack (spacing: 5) {
                        ZStack {
                            Circle()
                                .stroke(.iconOrange, lineWidth: 5)
                                .frame(width: 60, height: 60)
                            StandardTextView(label: "\(totalStarches)g", size: 14)
                        }
                        StandardTextView(label: "Starches", size: 12).offset(y: 5)
                    }
                }.padding(.bottom, 10)
                    LazyVGrid (columns: [GridItem(.flexible())], spacing: 10) {
                        ForEach(user.dailyMeal.decodeFoodJSON(), id: \.self) {food in
                            let brand = food.wholeFood.lowercased() == "yes" ? "Whole Food" : food.brandName?.brandFormater(brandOwner: food.brandOwner ?? "")
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.textField)
                                    .frame(width: 360)
                                HStack {
                                    VStack (alignment: .leading) {
                                        StandardTextView(label: brand ?? "", size: 12, textColor: .iconTeal)
                                        StandardTextView(label: food.description, size: 16, weight: .semibold)
                                        Spacer()
                                        HStack {
                                            StandardTextView(label: "Servings: \(food.consumedServings.description)", size: 12)
                                                .frame(width: 100, alignment: .leading)
                                            Spacer()
                                            StandardTextView(label: "Sugars: \(food.totalSugars.dataFormater())", size: 12)
                                                .frame(width: 100, alignment: .leading)
                                            StandardTextView(label: "Starches: \(food.totalStarches.dataFormater())", size: 12)
                                                .frame(width: 100, alignment: .leading)
                                            Spacer()
                                        }.padding(.top, 7)
                                    }
                                    Spacer()
                                }.padding(.vertical, 7).padding(.leading)
                            }
                            .frame(width: 360)
                            .overlay(alignment: .topTrailing) {
                                Menu {
                                    Button(action: {
                                        selectedFood = food
                                        editFoodSheetIsPresenting = true
                                        customServingPercentage = food.consumedServings.description
                                    }, label: {
                                        StandardTextView(label: "Edit", size: 16)
                                    })
                                    Button(action: {
                                        selectedFood = food
                                        notificationAlert = true
                                    }, label: {
                                        StandardTextView(label: "Delete", size: 16)
                                    })
                                } label: {
                                    Image(systemName: "ellipsis")
                                        .font(.system(size: 16))
                                        .foregroundStyle(.iconTeal)
                                        .padding(7)
                                }
                            }
                        }
                        NavigationLink(destination: FindMealFoodsScreen(mealType: mealType)) {
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
                }
                .padding(.vertical, 10)
            }
        }
        .onAppear {
            user.filterDailyMeal(mealType: mealType.label)
            getMealDataTotals()
        }
        .sheet(isPresented: $editFoodSheetIsPresenting, onDismiss: {
            editFoodSheetIsPresenting = false
        }) {
            let brand = selectedFood.wholeFood.lowercased() == "yes" ? "Whole Food" : selectedFood.brandName?.brandFormater(brandOwner: selectedFood.brandOwner ?? "")
            VStack (alignment: .leading, spacing: 10) {
                StandardTextView(label: user.selectedDay.formatted(.dateTime.month().day().year()), size: 14)
                StandardTextView(label: brand ?? "", size: 14, textColor: .iconTeal)
                StandardTextView(label: selectedFood.description, size: 20, weight: .semibold)
                HStack (spacing: 5) {
                    StandardTextView(label: "Servings: ", size: 14)
                    TextField("Servings: ", text: $customServingPercentage)
                        .keyboardType(.decimalPad)
                }
                Spacer()
                VStack {
                    Button {
                        Task {
                            selectedFood.totalCarbs = (((Float(selectedFood.totalCarbs) ?? 0) / selectedFood.consumedServings) * (Float(customServingPercentage) ?? 0)).description
                            selectedFood.totalSugars = (((Float(selectedFood.totalSugars) ?? 0) / selectedFood.consumedServings) * (Float(customServingPercentage) ?? 0)).description
                            selectedFood.totalStarches = (((Float(selectedFood.totalStarches) ?? 0) / selectedFood.consumedServings) * (Float(customServingPercentage) ?? 0)).description
                            selectedFood.consumedServings = Float(customServingPercentage) ?? 0
                            user.updateMealFood(mealFood: selectedFood)
                            await updateDailyMeals(meal: user.dailyMeal)
                            await user.getWeeklyMeals()
                            getMealDataTotals()
                            editFoodSheetIsPresenting = false
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 7)
                                .fill(.iconTeal)
                            StandardTextView(label: "Update Food", size: 16, weight: .semibold)
                        }
                    }
                }.frame(height: 40, alignment: .center)
            }
            .padding()
            .presentationDetents([.height(300)])
            .presentationDragIndicator(.automatic)
        }
        .alert("Confirm Update", isPresented: $notificationAlert) {
            HStack {
                Button("Update") {
                    deleteMealFood(toBeDeletedFood: selectedFood.id)
                    getMealDataTotals()
                    notificationAlert = false
                }
                Button("Cancel") {
                    notificationAlert = false
                }
            }
        } message: {
            Text("Please confirm that you are wanting to update/delete \(selectedFood.description)")
        }
    }
    
    func getMealDataTotals() {
        var tC: Float = 0
        var tSug: Float = 0
        var tStar: Float = 0
        
        for i in user.dailyMeal.decodeFoodJSON() {
            tC = tC + (Float(i.totalCarbs) ?? 0)
            tSug = tSug + (Float(i.totalSugars) ?? 0)
            tStar = tStar + (Float(i.totalStarches) ?? 0)
        }
        
        totalCarbs = String(tC).dataFormater()
        netCarbs = String(tSug + tStar).dataFormater()
        totalSugars = String(tSug).dataFormater()
        totalStarches = String(tStar).dataFormater()

    }
    
    func deleteMealFood(toBeDeletedFood: UUID) {
        var mealFoods: [MealFood] = user.dailyMeal.decodeFoodJSON()
        
        if mealFoods.count == 1 {
            Task {
                await user.deleteMeal()
                await user.getWeeklyMeals()
            }
        } else {
            mealFoods.removeAll(where: {$0.id == toBeDeletedFood})
            
            let jsonEncoder = JSONEncoder()
            jsonEncoder.outputFormatting = .prettyPrinted
            
            do {
                let encodeMeal = try jsonEncoder.encode(mealFoods)
                user.dailyMeal.foods = String(data: encodeMeal, encoding: .utf8)
                Task {
                    await user.updateDailyMeals()
                    await user.getWeeklyMeals()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func updateDailyMeals(meal: Meals) async {
        do {
            let result = try await Amplify.API.mutate(request: .update(meal))
            switch result {
            case .success(let model):
                print("Successfully updated daily meal: \(model)")

            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
            }
        } catch let error as APIError {
            print("Failed to update SavedLists - \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
}

#Preview {
    NavigationStack {
        MealFoodListScreen(mealType: .afternoonSnack)
            .environmentObject(User())
    }

}
