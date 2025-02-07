//
//  MealLoggingScreen.swift
//  CSID_Simple
//
//  Created by Vince Muller on 1/26/25.
//

import SwiftUI
import Amplify



struct MealLoggingScreen: View {
    
    
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
    @State var selectedDay: Date = Date.now
    @State private var dailyMeal: Meals = Meals()
    @State private var dailyMealFoods: [FoodDetails] = []
    

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
                        VStack {
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
                        ScrollView {
                            LazyVGrid (columns: [GridItem(.flexible())], spacing: 5) {
                                ForEach(dailyMealFoods, id: \.fdicID) {food in
                                    HStack {
                                        Text("\(food.brandOwner ?? "") | \(food.brandName ?? "")")
                                        Text(food.description)
                                    }
                                }.padding(.bottom, 5)
                            }
                        }
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
            .onAppear(perform: {
                filterDailyMeal(selectedDay: selectedDay, mealType: mealType.label)
            })
            .sheet(isPresented: $foodDetalsPresenting, onDismiss: {
                foodDetalsPresenting = false
            }) {
                FoodDetailsScreen(food: $selectedFood)
            }
            .sheet(isPresented: $logServingSizeSheetIsPresenting, onDismiss: {
                logServingSizeSheetIsPresenting = false
            }) {
                Button {
                    Task {
                        let d = Temporal.Date.init(selectedDay, timeZone: .none)
                        if (dailyMeal.mealType == nil) {
                            await User.shared.mealLogging(meal: Meal(mealDate: d, mealType: mealType.label, foods: [MealFood(fdicID: selectedFood.fdicID, customServingPercentage: 1.5)], additionalNotes: "Food tasted yummy and was safe"))
                        } else {
                            updateFoodsJson()
                            await updateDailyMeals(meal: dailyMeal)
                        }
                        await User.shared.getDailyMeals(selectedDay: selectedDay)
                        filterDailyMeal(selectedDay: selectedDay, mealType: mealType.label)
                    }
                } label: {
                    Text("Log Food")
                }

                Text("servings bottom sheet")
                    .presentationDetents([.height(300)])
                    .presentationDragIndicator(.automatic)
            }
        }
    }
    
    private func getMealFoodDetails() {
        //Build search terms "USDAFoodSearchTable.fdicID = 2700004"
        var searchTerms: [String] = []
        
        for i in dailyMeal.decodeFoodJSON() {
            searchTerms.append("USDAFoodSearchTable.fdicID = \(i.fdicID.description)")
        }
        
        let sT = searchTerms.joined(separator: " OR ")
        
        DispatchQueue(label: "search.serial.queue").async {
            let queryResult = DatabaseQueries.databaseSavedFoodsSearch(searchTerms: sT, databasePointer: databasePointer)
            print(queryResult)
            
            DispatchQueue.main.async {
                self.dailyMealFoods = queryResult
            }
        }
    }
    
    func updateFoodsJson() {
        var mealFoods: [MealFood] = dailyMeal.decodeFoodJSON()
        
        mealFoods.append(MealFood(fdicID: selectedFood.fdicID, customServingPercentage: 0.5))
        
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted

        do {
            let encodeMeal = try jsonEncoder.encode(mealFoods)
            dailyMeal.foods = String(data: encodeMeal, encoding: .utf8)!
        } catch {
            print(error.localizedDescription)
        }
    }
    
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
    
    func filterDailyMeal(selectedDay: Date, mealType: String) {
        let sD = Temporal.Date.init(selectedDay, timeZone: .autoupdatingCurrent)
        let d = User.shared.dailyMeals.filter {$0.mealDate?.iso8601FormattedString(format: .short, timeZone: .autoupdatingCurrent) == sD.iso8601FormattedString(format: .short, timeZone: .autoupdatingCurrent) }
        dailyMeal = d.first(where: {$0.mealType == mealType}) ?? Meals()
        getMealFoodDetails()
    }
    
    private func updateDailyMeals(meal: Meals) async {
        do {
            let result = try await Amplify.API.mutate(request: .update(meal))
            switch result {
            case .success(let model):
                print("Successfully updated daily meal: \(model)")
                Task {
                    await User.shared.getDailyMeals(selectedDay: selectedDay)
                }
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
        MealLoggingScreen(mealType: .breakfast, selectedDay: Date.now)
    }
}

