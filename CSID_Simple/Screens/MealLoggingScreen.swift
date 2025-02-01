//
//  MealLoggingScreen.swift
//  CSID_Simple
//
//  Created by Vince Muller on 1/26/25.
//

import SwiftUI

enum MealLoggingScreenTab: CaseIterable, Identifiable {
    case search, savedMeals
    var id: Self { self }
    var label: String {
        switch self {
        case .search:
            return "Search"
        case .savedMeals:
            return "Saved Meals"
        }
    }
}

struct MealLoggingScreen: View {
    
    
    var mealType: MealType
    @FocusState private var isFocused: Bool
    
    @State private var logServingSizeSheetIsPresenting: Bool = false
    @State private var selectedMealTab: MealLoggingScreenTab = .search
    @State private var searchText: String = ""
    @State private var search: Search = .isNotFocused
    @State private var selectedSort: String = "Relevance"
    @State private var selectedFilter: SearchFilter = .allFoods
    @State private var searchResults: [FoodDetails] = []
    @State private var activeSearch: Bool = false
    @State private var selectedFood: FoodDetails = FoodDetails(searchKeyWords: "", fdicID: 0, brandedFoodCategory: "", description: "", servingSize: 0, servingSizeUnit: "", carbs: "", totalSugars: "", totalStarches: "", wholeFood: "")
    @State private var foodDetalsPresenting: Bool = false


    
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
                        SearchBarView(searchText: $searchText, isFocused: $isFocused, searchState: $search, resetSearch: resetSearch, searchFoods: searchFoods)
                        SortResultsView(selectedSort: $selectedSort)
                            .onChange(of: selectedSort) {
                                search == .isFocused ? searchFoods() : nil
                            }
                    }.padding(.horizontal)
                    switch search {
                    case .isNotFocused:
                        Text("Foods and Saved Meals will go here")
                            .offset(y: 100)
                    case .isFocused:
                        SearchFiltersView(selectedFilter: $selectedFilter, searchText: searchText, searchFoods: searchFoods)
                        
                        MealLoggingSearchResultsView(isPresenting: $foodDetalsPresenting, logServingSizeSheetIsPresenting: $logServingSizeSheetIsPresenting, selectedFood: $selectedFood, searchResults: $searchResults, selectedSort: selectedSort)
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
                Text("servings bottom sheet")
                    .presentationDetents([.height(300)])
                    .presentationDragIndicator(.automatic)
            }
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
}

#Preview {
    NavigationStack {
        MealLoggingScreen(mealType: .breakfast)
    }
}

