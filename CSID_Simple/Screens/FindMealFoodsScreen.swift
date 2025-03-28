//
//  MealLoggingScreen.swift
//  CSID_Simple
//
//  Created by Vince Muller on 1/26/25.
//

import SwiftUI
import Amplify


struct DailyMealFoods: Identifiable {
    var id = UUID()
    var mealFood: MealFood?
    var foodDetails: FoodDetails?
}

struct FindMealFoodsScreen: View {
    @EnvironmentObject var user: User
    @Environment(\.presentationMode) var presentationMode
    
    var mealType: MealType
    @FocusState private var isFocused: Bool
    
    @State private var logServingSizeSheetIsPresenting: Bool = false
    @State private var selectedMealTab: MealLoggingScreenTab = .search
    @State private var searchText: String = ""
    @State private var search: Search = .isNotFocused
    @State private var selectedSort: String = "Relevance"
    @State private var selectedFilter: SearchFilter = .allFoods
    private let searchFilters: [SearchFilter] = SearchFilter.allCases
    @State private var searchResults: [FoodDetails] = []
    @State private var activeSearch: Bool = false
    @State private var selectedFood: FoodDetails = FoodDetails(searchKeyWords: "", fdicID: 0, brandedFoodCategory: "", description: "", servingSize: 0, servingSizeUnit: "", carbs: "", totalSugars: "", totalStarches: "", wholeFood: "")
    @State private var foodDetalsPresenting: Bool = false
    @State private var customServingPercentage: String = "1"
    @State private var notificationAlert: Bool = false
    
    @State private var navigateToMealFoodList = false
    

    private let sortingOptions = ["Relevance",
                                  "Carbs (Low to High)",
                                  "Carbs (High to Low)",
                                  "Sugars (Low to High)",
                                  "Sugars (High to Low)",
                                  "Starches (Low to High)",
                                  "Starches (High to Low)"]

    
    var body: some View {
        ZStack (alignment: .topLeading) {
            BackgroundView()
                .navigationTitle(mealType.label)
            VStack (spacing: 0) {
                HStack {
                    ForEach(MealLoggingScreenTab.allCases, id: \.id) { tab in
                        tab.label == "Meal List" ? nil : VStack {
                            Text(tab.label)
                                .font(.system(size: 14))
                                .foregroundStyle(selectedMealTab == tab ? .iconTeal : .white)
                                .onTapGesture {
                                    withAnimation(.smooth) {
                                        selectedMealTab = tab
                                    }
                                }
                            Rectangle()
                                .fill(selectedMealTab == tab ? .iconTeal : .clear)
                                .frame(height: 1)
                        }
                    }
                }.padding()
                switch selectedMealTab {
                case .search:
                    HStack (spacing: 10) {
                        ZStack (alignment: .leading) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.textField)
                                .frame(width: 300, height: 40)
                            HStack {
                                Image(systemName:  search != .isNotFocused ? "arrow.left" :  "magnifyingglass")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(.white.opacity(0.6))
                                    .onTapGesture {
                                        if search != .isNotFocused {
                                            resetSearch()
                                        }
                                    }
                                ZStack (alignment: .leading) {
                                    searchText.count > 0 ? nil : SearchCarouselView()
                                    TextField("", text: $searchText)
                                        .foregroundColor(.white)
                                        .frame(width: 245, height: 35)
                                        .focused($isFocused)
                                        .onChange(of: isFocused, {
                                            if isFocused == true {
                                                search = .isFocused
                                            }
                                        })
                                        .onSubmit {
                                            searchFoods()
                                        }
                                }
                            }.padding(.leading)
                        }
                        Menu {
                            Picker("", selection: $selectedSort) {
                                ForEach(sortingOptions, id: \.self){ option in
                                    Button(action: {
                                        self.selectedSort = option
                                    }, label: {
                                        Text(option)
                                    })
                                }
                            }
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.textField)
                                    .frame(width: 40, height: 40)
                                Image(systemName: "arrow.up.and.down.text.horizontal")
                                    .foregroundColor(.white)
                            }
                        }
                        .onChange(of: selectedSort) {
                            search == .isFocused ? searchFoods() : nil
                        }
                    }
                    .padding(.vertical, 5) //adsfadsf
                    switch search {
                    case .isNotFocused:
                        Text("")
                    case .isFocused:
                        LazyVGrid(columns: [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]) {
                            ForEach(searchFilters, id: \.self) { filter in
                                Button(action: {selectedFilter = filter; searchText.isEmpty ? nil : searchFoods()}, label: {
                                    Text(filter.selected)
                                        .font(.system(size: 13, weight: selectedFilter.selected == filter.selected ? .bold : .semibold))
                                        .foregroundStyle( selectedFilter.selected == filter.selected ? .white :
                                                            .white.opacity(0.3))
                                })
                                .background(
                                    RoundedRectangle(cornerRadius: 7)
                                        .fill(.clear)
                                        .stroke(selectedFilter.selected == filter.selected ? .white : .white.opacity(0.3), lineWidth: selectedFilter.selected == filter.selected ? 2 : 1)
                                        .frame(width: 105, height: 30))
                            }
                        }.padding(.horizontal, 25).padding(.vertical, 20)
                        MealLoggingSearchResultssView(isPresenting: $foodDetalsPresenting, logServingSizeSheetIsPresenting: $logServingSizeSheetIsPresenting, selectedFood: $selectedFood, searchResults: $searchResults, selectedSort: selectedSort)
                        searchResults.isEmpty ? nil :
                        Text("\(searchResults.count) foods found")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.white)
                    case .searchInProgress:
                        progressIndicator
                    }
                case .savedMeals:
                    Text("Saved Meals List will go here")
                        .offset(y: 100)
                }
            }
            .sheet(isPresented: $foodDetalsPresenting, onDismiss: {
                foodDetalsPresenting = false
            }) {
                FoodDetailsScreen(food: $selectedFood)
            }
            .sheet(isPresented: $logServingSizeSheetIsPresenting, onDismiss: {
                logServingSizeSheetIsPresenting = false
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
                                let d = Temporal.Date.init(user.selectedDay.getNormalizedDate(adjustor: 0), timeZone: .none)
                                if user.dailyMealCheck(mealType: mealType.label) {
                                    user.updateMeal(selectedFood: selectedFood, consumedServings: Float(customServingPercentage) ?? 1.0)
                                    notificationAlert = true
                                    await updateDailyMeals(meal: user.dailyMeal)
                                    await user.getWeeklyMeals()
                                } else {
                                    await user.logNewMeal(meal: Meal(mealDate: d, mealType: mealType.label, foods: [MealFood(fdicID: selectedFood.fdicID, brandOwner: selectedFood.brandOwner, brandName: selectedFood.brandName, description: selectedFood.description, consumedServings: Float(customServingPercentage) ?? 1.0, totalCarbs: ((Float(selectedFood.carbs) ?? 0) * (Float(customServingPercentage) ?? 0)).description, totalFiber: "", netCarbs: "", totalSugars: ((Float(selectedFood.totalSugars) ?? 0) * (Float(customServingPercentage) ?? 0)).description, totalStarches: ((Float(selectedFood.totalStarches) ?? 0) * (Float(customServingPercentage) ?? 0)).description, wholeFood: selectedFood.wholeFood)], additionalNotes: "Food tasted yummy and was safe"))
                                    await user.getWeeklyMeals()
                                    // **Delay Navigation to Allow UI Update**
                                    mealType.label.contains("Snack") ? self.presentationMode.wrappedValue.dismiss() : nil
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        navigateToMealFoodList = true
                                    }
                                }
                            }
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 7)
                                    .fill(.iconTeal)
                                StandardTextView(label: "Log Food", size: 16, weight: .semibold)
                            }
                        }
                    }.frame(height: 40, alignment: .center)
                }
                .padding()
                .presentationDetents([.height(300)])
                .presentationDragIndicator(.automatic)
            }
            NavigationLink(
                destination: MealFoodListScreen(mealType: mealType),
                isActive: $navigateToMealFoodList
            ) {
                EmptyView()
            }
            .hidden()
            .alert("Meal Updated", isPresented: $notificationAlert) {
                HStack {
                    Button("Ok") {
                        notificationAlert = false
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            } message: {
                Text("You have successfully added \(selectedFood.description) to \(mealType.label)")
            }
        }
        .sheet(isPresented: $foodDetalsPresenting, onDismiss: {
            foodDetalsPresenting = false
        }) {
            FoodDetailsScreen(food: $selectedFood)
        }
    }
    
    //Brand owner and/or brand name
    //Food description
    //Total and net carbs
    //Total sugars
    //Total starches
    //Consumed serving that automatically adjusts totals presented
    //Log Food button
    
    private var progressIndicator: some View {
        VStack {
            Image("csidAssistLogo")
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(.white.opacity(0.5))
                .frame(width: 160, height: 160)
        }.offset(y: 150)
    }
    
    func resetSearch() {
        isFocused = false
        searchText = ""
        searchResults = []
        search = .isNotFocused
        selectedSort = "Relevance"
        selectedFilter = .allFoods
    }
    
    private func searchFoods() {
        search = .searchInProgress
        DispatchQueue(label: "search.serial.queue").async {
            let queryResult = DatabaseQueries.databaseSearch(
                searchTerms: buildSearchTerms(),
                databasePointer: databasePointer,
                sortFilter: getSortFilter()
            )
            DispatchQueue.main.async {
                self.searchResults = queryResult
                search = .isFocused
            }
        }
    }
    
    private func buildSearchTerms() -> String {
        let searchComponents = searchText.lowercased().components(separatedBy: " ").filter { !$0.isEmpty }
        let filterClause = selectedFilter == .wholeFoods ? "USDAFoodSearchTable.wholeFood='yes' AND" :
                           selectedFilter == .brandedFoods ? "USDAFoodSearchTable.wholeFood='no' AND" : ""
        
        let removeNullValues: String = {
            switch selectedSort {
            case "Relevance": return ""
            case "Sugars (Low to High)": return "USDAFoodSearchTable.totalSugars IS NOT NULL AND"
            case "Sugars (High to Low)": return "USDAFoodSearchTable.totalSugars IS NOT NULL AND"
            case "Starches (Low to High)": return "USDAFoodSearchTable.totalStarches IS NOT NULL AND"
            case "Starches (High to Low)": return "USDAFoodSearchTable.totalStarches IS NOT NULL AND"
            case "Carbs (Low to High)": return "USDAFoodSearchTable.carbs IS NOT NULL AND"
            case "Carbs (High to Low)": return "USDAFoodSearchTable.carbs IS NOT NULL AND"
            default: return ""
            }
        }()
        
        return "\(filterClause) \(removeNullValues) \(searchComponents.map { "USDAFoodSearchTable.searchKeyWords LIKE '%\($0)%'" }.joined(separator: " AND "))"
    }
    
    private func getSortFilter() -> String {
        switch selectedSort {
        case "Relevance": return "wholeFood DESC, length(description)"
        case "Sugars (Low to High)": return "CAST(totalSugars AS REAL)"
        case "Sugars (High to Low)": return "CAST(totalSugars AS REAL) DESC"
        case "Starches (Low to High)": return "CAST(totalStarches AS REAL)"
        case "Starches (High to Low)": return "CAST(totalStarches AS REAL) DESC"
        case "Carbs (Low to High)": return "CAST(carbs AS REAL)"
        case "Carbs (High to Low)": return "CAST(carbs AS REAL) DESC"
        default: return "wholeFood DESC, length(description)"
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
        FindMealFoodsScreen(mealType: .breakfast)
    }
}

