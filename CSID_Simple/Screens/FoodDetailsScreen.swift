//
//  FoodDetailsScreen.swift
//  CSID_Simple
//
//  Created by Vince Muller on 11/5/24.
//

import SwiftUI
import Amplify
import AWSPluginsCore
import AWSAPIPlugin



struct FoodDetailsScreen: View {

    @EnvironmentObject var user: User
    
    @State private var nutData: NutrientData?
    @State private var adjustedNutrition: NutrientData?
    @State private var isLoaded: Bool = false
    @State private var selectedList: String = ""
    @State private var customServing: String = ""
    @State private var selectedIngredientList: Ingredients = .sucroseIngredients
    @State private var sucroseAndStarchIngredients: [[String]] = [[],[]]
    @State private var tolerationRatings: [TolerationRating] = []
    @State private var tolerationRating: Toleration = .inconclusive
    @State private var tolerationChunks = TolerationChunks(canNotTolerate: [], tolerateWithStipulations: [], canTolerate: [])
    @State private var tolerationWidth: Float = 0.0
    @State private var selectedToleration: Toleration?
    @State private var errorAlert: Bool = false
    @State private var errorComment: String = "An error has occurred, please close application and try again."
    @State private var savedListScreenPresenting: Bool = false
    
    @Binding var food: FoodDetails
    
    
    private var isFavorite: Bool {
        if user.userSavedFoods.contains(where: {$0.fdicID == food.fdicID}) {
            return true
        } else {
            return false
        }
    }
    
    var helper = Helpers()
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
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
                            Button(action: {savedListScreenPresenting = true}, label: {
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
                                                .stroke(.iconRed, lineWidth: 3)
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
                            Text(selectedIngredientList != .tolerationRatings ? "\(selectedIngredientList.label) Ingredients" : selectedIngredientList.label)
                                .foregroundStyle(.white)
                                .font(.system(size: 20, weight: .semibold))
                                .frame(width: 360, alignment: .leading)
                            ScrollView (.horizontal) {
                                HStack {
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
                                    }.frame(height: 40, alignment: .leading).padding(.horizontal, 5)
                                }
                            }
                            GeometryReader(content: { geometry in
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
                                        ScrollView {
                                            Text(nutData?.ingredients ?? "")
                                                .font(.system(size: 12))
                                                .lineLimit(nil)
                                                .frame(width: geometry.size.width - 30, alignment: .center)
                                                .padding()
                                        }.frame(height: geometry.size.height - 10)
                                    case .tolerationRatings:
                                        VStack {
                                            HStack {
                                                RatingsPieChartView(tolerationChunks: $tolerationChunks, tolerationRatingCount:
                                                                        tolerationRatings.count, majorityLabel: tolerationRating.label, width: geometry.size.width * 0.33)
                                                    .padding(.top, 10)
                                                VStack (alignment: .leading) {
                                                    HStack {
                                                        Circle()
                                                            .fill(tolerationRatings.count == 0 ? .white.opacity(0.15) : .red)
                                                            .frame(width: 12)
                                                        Text("Can Not Tolerate: \(tolerationChunks.canNotTolerate.count)")
                                                            .font(.system(size: 10))
                                                            .foregroundStyle(.white.opacity(tolerationRatings.count == 0 ? 0.15 : 1.0))
                                                    }
                                                    HStack {
                                                        Circle()
                                                            .fill(tolerationRatings.count == 0 ? .white.opacity(0.15) : .iconYellow)
                                                            .frame(width: 12)
                                                        Text("Tolerate With Stipulations: \(tolerationChunks.tolerateWithStipulations.count)")
                                                            .font(.system(size: 10))
                                                            .foregroundStyle(.white.opacity(tolerationRatings.count == 0 ? 0.15 : 1.0))
                                                    }
                                                    HStack {
                                                        Circle()
                                                            .fill(tolerationRatings.count == 0 ? .white.opacity(0.15) : .iconTeal)
                                                            .frame(width: 12)
                                                        Text("Can Tolerate: \(tolerationChunks.canTolerate.count)")
                                                            .font(.system(size: 10))
                                                            .foregroundStyle(.white.opacity(tolerationRatings.count == 0 ? 0.15 : 1.0))
                                                    }
                                                }.padding(.leading, 25)
                                            }
                                            Text("\(tolerationRatings.count) Ratings")
                                                .foregroundStyle(.white.opacity(0.3))
                                                .frame(width: 350, alignment: .trailing)
                                            Rectangle()
                                                .fill(.white.opacity(0.5))
                                                .frame(height: 1)
                                                .padding(.bottom, 15)
                                                .padding(.horizontal, 10)
                                            NavigationLink(destination: CreateRatingAndReviewScreen(fdicID: food.fdicID)) {
                                                Text("Write Review")
                                                    .font(.system(size: 18))
                                                    .frame(width: 200, height: 40)
                                                    .foregroundStyle(.black)
                                                    .background(
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .fill(.white))
                                            }.buttonStyle(PlainButtonStyle())
                                        }
                                        .overlay(alignment: .topTrailing) {
                                            NavigationLink(destination: RatingsAndReviewsScreen(ratings: tolerationRatings)) {
                                                Text("See All")
                                                    .font(.system(size: 16, weight: .semibold))
                                                    .foregroundStyle(.iconTeal)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                            .padding(.trailing, 15)
                                            .disabled(tolerationRatings.isEmpty ? true : false)
                                        }
                                    }
                                }
                            })
                        }
                    }
                    .padding()
                    .onAppear(perform: {
                        getNutDetails()
                        Task {
                            await getTolerationRatings()
                        }
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
                    .sheet(isPresented: $savedListScreenPresenting, onDismiss: {
                        savedListScreenPresenting = false
                    }) {
                        FoodDetailsSavedListScreen(fdicID: food.fdicID)
                            .presentationDetents([.height(300)])
                            .presentationDragIndicator(.automatic)
                    }
                    .alert("Error", isPresented: $errorAlert) {
                        Button("Ok") {
                            errorAlert = false
                        }
                    } message: {
                        Text(errorComment)
                    }
                }
            }
        }
        .colorScheme(.dark)
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
    
    private func getTolerationRatings() async {
        let ratings = TolerationRating.keys
        let predicate = ratings.fdicID == food.fdicID
        let request = GraphQLRequest<TolerationRating>.list(TolerationRating.self, where: predicate)
        do {
            let result = try await Amplify.API.query(request: request)
            switch result {
            case .success(let ratings):
                print("Successfully retrieved list of todos: \(ratings.count)")
                tolerationRatings = []
                tolerationChunks.canNotTolerate.removeAll()
                tolerationChunks.tolerateWithStipulations.removeAll()
                tolerationChunks.canTolerate.removeAll()
                for r in ratings {
                    tolerationRatings.append(r)
                    if r.rating == "0" {
                        tolerationChunks.canNotTolerate.append(r)
                    } else if r.rating == "1" {
                        tolerationChunks.tolerateWithStipulations.append(r)
                    } else {
                        tolerationChunks.canTolerate.append(r)
                    }
                }
                tolerationMajority()
            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
                errorAlert = true
                errorComment = error.errorDescription
            }
        } catch let error as APIError {
            print("Failed to query list of todos: ", error)
            errorAlert = true
            errorComment = error.errorDescription
        } catch {
            print("Unexpected error: \(error)")
            errorAlert = true
            errorComment = error.localizedDescription
        }
    }
    
    private func tolerationMajority() {
        if tolerationChunks.canNotTolerate.count > tolerationChunks.tolerateWithStipulations.count && tolerationChunks.canNotTolerate.count > tolerationChunks.canTolerate.count {
            tolerationRating = .canNotTolerate
        } else if tolerationChunks.tolerateWithStipulations.count > tolerationChunks.canNotTolerate.count && tolerationChunks.tolerateWithStipulations.count > tolerationChunks.canTolerate.count {
            tolerationRating = .canTolerateWithStipulations
        } else if tolerationChunks.canTolerate.count > tolerationChunks.canNotTolerate.count && tolerationChunks.canTolerate.count > tolerationChunks.tolerateWithStipulations.count {
            tolerationRating = .canTolerate
        } else {
            tolerationRating = .inconclusive
        }
    }
    
}

//#Preview {
//    FoodDetailsScreen(food: .constant(FoodDetails(searchKeyWords: "", fdicID: 2154952, brandOwner: "M&M Mars", brandName: "Snickers", brandedFoodCategory: "Confectionary and Sweets", description: "S'mores Marsh mallow Sauce", servingSize: 12, servingSizeUnit: "g", carbs: "25", totalSugars: "18", totalStarches: "7", wholeFood: "no")))
//}
