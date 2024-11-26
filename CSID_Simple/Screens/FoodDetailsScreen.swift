//
//  FoodDetailsScreen.swift
//  CSID_Simple
//
//  Created by Vince Muller on 11/5/24.
//

import SwiftUI


enum Ingredients: Identifiable, CaseIterable {
    case sucroseIngredients, completeIngredientList
    var id: Self { self }
    var label: String {
        switch self {
        case .sucroseIngredients:
            return "Sucrose"
        case .completeIngredientList:
            return "Complete"
        }
    }
}

struct FoodDetailsScreen: View {
    
    @State private var nutData: NutrientData?
    @State private var adjustedNutrition: NutrientData?
    @State private var isLoaded: Bool = false
    @State private var isFavorite: Bool = false
    @State private var customServing: String = ""
    @State private var selectedIngredientList: Ingredients = .sucroseIngredients
    @State private var sucroseAndStarchIngredients: [[String]] = [[],[]]
    
    @State var food: FoodDetails
    
    var helper = Helpers()
    
    var body: some View {
        
        ZStack (alignment: .topLeading) {
            BackgroundView()
            VStack (spacing: 10) {
                HStack {
                    Text(food.description)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .lineLimit(5)
                        .minimumScaleFactor(0.7)
                        .frame(width: 320, height: 80, alignment: .bottomLeading)
                    Button(action: {isFavorite.toggle()}, label: {
                        Image(systemName: isFavorite ? "bookmark.fill" : "bookmark")
                            .font(.system(size: 25))
                            .foregroundStyle(.iconTeal)
                            .offset(y: 5)
                    })
                    .frame(height: 80, alignment: .bottom)
                }
                Text(food.brandedFoodCategory)
                    .font(.system(size: 12))
                    .foregroundStyle(.white.opacity(0.6))
                    .frame(width: 358, alignment: .leading)
                ZStack (alignment: .center) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.textField)
                        .frame(width: 365, height: 60)
                    VStack (alignment: .leading, spacing: 6) {
                        HStack {
                            Text("Brand Owner:")
                                .foregroundStyle(.white)
                                .font(.system(size: 12, weight: .semibold))
                                .padding(.leading, 10)
                            Text(food.brandOwner ?? "")
                                .foregroundStyle(.white)
                                .font(.system(size: 12))
                        }
                        HStack {
                            Text("Brand Name:")
                                .foregroundStyle(.white)
                                .font(.system(size: 12, weight: .semibold))
                                .padding(.leading, 10)
                            Text(food.brandName ?? "")
                                .foregroundStyle(.white)
                                .font(.system(size: 12))
                        }
                    }
                    .frame(width: 365, height: 50, alignment: .leading)
                }
                HStack (spacing: 10) {
                    ZStack (alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.textField)
                        HStack (alignment: .center) {
                            Text("Serving Size:")
                                .foregroundStyle(.white)
                                .font(.system(size: 14, weight: .semibold))
                                .padding(.leading, 10)
                            Text("\(food.servingSize.formatted())\(food.servingSizeUnit)")
                                .foregroundStyle(.white)
                                .font(.system(size: 14))
                        }
                    }.frame(width: 225, height: 50)
                    TextField("Custom Serving", text: $customServing)
                        .foregroundStyle(.white)
                        .font(.system(size: 14, weight: .semibold))
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .frame(height: 48)
                        .keyboardType(.numberPad)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.white.opacity(0.4))
                        )
                }
                .frame(width: 365, height: 50, alignment: .leading)
                
                HStack (spacing: 10) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.textField)
                        HStack (spacing: 25) {
                            VStack (spacing: 10) {
                                ZStack {
                                    Circle()
                                        .stroke(.iconTeal, lineWidth: 3)
                                        .frame(width: 70)
                                    Text((adjustedNutrition == nil ? nutData?.totalSugars : adjustedNutrition?.totalSugars) ?? "")
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
                                        .stroke(.iconOrange, lineWidth: 3)
                                        .frame(width: 70)
                                    Text((adjustedNutrition == nil ? nutData?.totalStarches : adjustedNutrition?.totalStarches) ?? "")
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundStyle(.white)
                                }
                                Text("Total Starches")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 12, weight: .semibold))
                            }
                        }.offset(y: 5)
                    }.frame(width: 225, height: 130)
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.textField)
                        VStack (spacing: 5) {
                            Text((adjustedNutrition == nil ? nutData?.carbs : adjustedNutrition?.carbs) ?? "")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.white)
                            Text("Total Carbs")
                                .foregroundStyle(.white)
                                .font(.system(size: 12, weight: .semibold))
                            Rectangle()
                                .fill(.white)
                                .frame(height: 2)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                            Text((adjustedNutrition == nil ? nutData?.netCarbs : adjustedNutrition?.netCarbs) ?? "")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.white)
                            Text("Net Carbs")
                                .foregroundStyle(.white)
                                .font(.system(size: 12, weight: .semibold))
                        }
                    }.frame(height: 130)
                }
                VStack (spacing: 0) {
                    Text("\(selectedIngredientList.label) Ingredients")
                        .font(.system(size: 20, weight: .semibold))
                        .frame(width: 360, alignment: .leading)
                    ScrollView (.horizontal) {
                        HStack {
                            ForEach(Ingredients.allCases) { ingredients in
                                Button(action: {selectedIngredientList = ingredients}, label: {
                                    Text(ingredients.label)
                                        .foregroundStyle(.white.opacity(selectedIngredientList == ingredients ? 1.0 : 0.4))
                                        .font(.system(size: 12, weight: .semibold))
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                })
                                .background(
                                    RoundedRectangle(cornerRadius: 7)
                                        .fill(selectedIngredientList == ingredients ? .iconTeal : .textField)
                                )
                                
                            }
                        }.frame(height: 40).padding(.horizontal, 5)
                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.textField)
                        switch selectedIngredientList {
                        case .sucroseIngredients:
                            HStack {
                                VStack (alignment: .leading, spacing: 5) {
                                    Text("Sucrose detected in:")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundStyle(.iconTeal)
                                    List(sucroseAndStarchIngredients[0], id: \.self) { ingredient in
                                        Text(ingredient.trimmingCharacters(in: .whitespacesAndNewlines).capitalized)
                                            .font(.system(size: 12))
                                            .foregroundStyle(.white)
                                            .listRowBackground(Color.clear)
                                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                            .listRowSpacing(0)
                                    }.listStyle(.plain)
                                        .environment(\.defaultMinListRowHeight, 20)
                                }.padding(.top, 10)
                                Spacer()
                                VStack (alignment: .leading, spacing: 5) {
                                    Text("Other sugars detected in:")
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundStyle(.iconTeal)
                                    List(sucroseAndStarchIngredients[1], id: \.self) { ingredient in
                                        Text(ingredient.trimmingCharacters(in: .whitespacesAndNewlines).capitalized)
                                            .font(.system(size: 12))
                                            .foregroundStyle(.white)
                                            .listRowBackground(Color.clear)
                                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                            .listRowSpacing(0)
                                    }.listStyle(.plain)
                                        .environment(\.defaultMinListRowHeight, 20)
                                }.padding(.top, 10)
                            }.frame(width: 340)
                        case .completeIngredientList:
                            GeometryReader(content: { geometry in
                                ScrollView {
                                    Text(nutData?.ingredients ?? "")
                                        .font(.system(size: 12))
                                        .lineLimit(nil)
                                        .frame(width: geometry.size.width - 30, alignment: .center)
                                        .padding()
                                }.frame(height: geometry.size.height - 10)
                            })
                        }
                    }
                }
            }
            .padding()
            .onAppear(perform: {
                getNutDetails()
            })
            .onTapGesture {
                hideKeyBoard()
            }
            .onChange(of: customServing) {
                adjustedNutrition = nil
                
                guard !customServing.isEmpty else {
                    return
                }
                
                guard let nD = nutData else {
                    return
                }
                
                adjustedNutrition = helper.customServingCalculator(actualServingSize: food.servingSize, customServing: customServing, nutrientData: nD)
            }
        }
    }
    
    func getNutDetails() {

        DispatchQueue(label: "nutrition.serial.queue").async {
            let queryResult = DatabaseQueries.getNutrientData(fdicID: self.food.fdicID, databasePointer: databasePointer)
            
            // Update UI on main queue
            DispatchQueue.main.async {
                self.nutData = queryResult
                self.isLoaded = true
                self.sucroseAndStarchIngredients = helper.findSucroseIngredients(in: nutData?.ingredients ?? "")
            }
        }

    }
}

#Preview {
    FoodDetailsScreen(food: FoodDetails(searchKeyWords: "", fdicID: 2154952, brandOwner: "M&M Mars", brandName: "Snickers", brandedFoodCategory: "Confectionary and Sweets", description: "S'mores Marsh mallow Sauce", servingSize: 12, servingSizeUnit: "g", carbs: "25", totalSugars: "18", totalStarches: "7", wholeFood: "no"))
}
