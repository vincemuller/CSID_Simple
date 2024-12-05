//
//  ContentView.swift
//  CSID_Simple
//
//  Created by Vince Muller on 10/29/24.
//

import SwiftUI

enum HomeScreenSections: Identifiable, CaseIterable {
    case activity, meals, lists
    var id: Self { self }
    var label: String {
        switch self {
        case .activity:
            return "Activity"
        case .meals:
            return "Meals"
        case .lists:
            return "Lists"
        }
    }
}

enum Search: CaseIterable {
    case isNotFocused, isFocused, searchInProgress
}

enum SearchFilter: Identifiable, CaseIterable {
    case wholeFoods, allFoods, brandedFoods
    var id: Self { self }
    var selected: String {
        switch self {
        case .wholeFoods:
            return "Whole Foods"
        case .allFoods:
            return "All Foods"
        case .brandedFoods:
            return "Branded Foods"
        }
    }
}

struct HomeScreen: View {
    @EnvironmentObject var sessionViewModel: SessionViewModel
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    @FocusState private var isFocused: Bool
    @StateObject private var viewModel = ViewModel()
    @State private var opacityAnimation: CGFloat = 0.3
    
    @State private var sections: HomeScreenSections = .activity
    @State private var search: Search = .isNotFocused
    @State private var searchText: String = ""
    @State private var selectedSort: String = "Relevance"
    @State private var selectedFilter: SearchFilter = .allFoods
    @State private var searchResults: [FoodDetails] = []
    @State private var activeSearch: Bool = false
    
    
    var body: some View {
        
        NavigationStack {
            ZStack (alignment: .top) {
                BackgroundView()
                    .navigationTitle("CSIDAssist")
                VStack (spacing: 0) {
                    HStack (spacing: 10) {
                        SearchBarView(searchText: $searchText, isFocused: $isFocused, searchState: $search, resetSearch: resetSearch, searchFoods: searchFoods)
                        SortResultsView(selectedSort: $selectedSort)
                            .onChange(of: selectedSort) {
                                search == .isFocused ? searchFoods() : nil
                            }
                    }
                .padding(.top, 10)
                    switch search {
                    case .isNotFocused:
                        List {
                            ForEach(HomeScreenSections.allCases) {section in
                                Section {
                                    if section == .activity {
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(.textField)
                                            .frame(width: 350, height: 100)
                                    } else if section == .meals {
                                        MealTypeSectionView()
                                    } else {
                                        SavedListsView(createListScreenPresenting: $viewModel.createListScreenPresenting)
                                    }
                                } header: {
                                    Text(section.label)
                                        .font(.system(size: 30, weight: .semibold))
                                        .foregroundStyle(.white)
                                }
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 7, leading: 18, bottom: 0, trailing: 15))
                        }
                        .listStyle(.plain)
                    case .isFocused:
                        SearchFiltersView(selectedFilter: $selectedFilter, searchText: searchText, searchFoods: searchFoods)
                        
                        SearchResultsView(isPresenting: $viewModel.foodDetalsPresenting, selectedFood: $viewModel.selectedFood, compareQueue: $viewModel.compareQueue, searchResults: searchResults, selectedSort: selectedSort)
                        
                        searchResults.isEmpty ? nil :
                        HStack (spacing: 10) {
                            viewModel.compareQueue.count == 2 ? nil :
                            Text("\(searchResults.count) foods found")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(.white)

                            viewModel.compareQueue.count != 2 ? nil :
                            Button(action: {
                                viewModel.compareQueue = []
                            }, label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 7)
                                        .stroke(.iconOrange)
                                        .frame(width: 120, height: 30)
                                    Text("Clear Foods")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundStyle(.iconOrange)
                                }
                            })
                            
                            viewModel.compareQueue.count != 2 ? nil :
                            Button(action: {
                                if viewModel.compareQueue.count == 2 {
                                    viewModel.compareFoodsSheetPresenting = true
                                }
                            }, label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 7)
                                        .stroke(.iconTeal)
                                        .frame(width: 120, height: 30)
                                    Text("Compare Foods")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundStyle(.iconTeal)
                                }
                            })
                        }.frame(height: 30).offset(y: 8)

                    case .searchInProgress:
                        progressIndicator
                    }
                }
            }
        }
        .overlay(alignment: .topLeading, content: {
            topLeadingLogo
        })
        .ignoresSafeArea()
        .sheet(isPresented: $viewModel.compareFoodsSheetPresenting, onDismiss: {
            viewModel.compareFoodsSheetPresenting = false
        }) {
            ComparisonScreen(foods: viewModel.compareQueue, nutrition: $viewModel.comparisonNutData)
        }
        .sheet(isPresented: $viewModel.foodDetalsPresenting, onDismiss: {
            viewModel.foodDetalsPresenting = false
        }) {
            FoodDetailsScreen(food: viewModel.selectedFood)
        }
        .sheet(isPresented: $viewModel.createListScreenPresenting, onDismiss: {
            viewModel.createListScreenPresenting = false
        }) {
            CreateListScreen()
        }
        .onAppear(perform: initializeDatabase)
        .onChange(of: viewModel.compareQueue) {
            if viewModel.compareQueue.count == 2 {
                getComparisonNutDetails()
            }
        }
    }
    
    private var topLeadingLogo: some View {//.
        Image("csidAssistLogo")
            .resizable()
            .frame(width: 70, height: 70)
            .safeAreaPadding(.top)
            .padding(.leading)
            .padding(.top, 20)
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
        viewModel.compareQueue = []
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
    
    private func getComparisonNutDetails() {
        DispatchQueue(label: "nutrition.serial.queue").async {
            let queryResult1 = DatabaseQueries.getNutrientData(fdicID: viewModel.compareQueue[0].fdicID, databasePointer: databasePointer)
            let queryResult2 = DatabaseQueries.getNutrientData(fdicID: viewModel.compareQueue[1].fdicID, databasePointer: databasePointer)
            
            DispatchQueue.main.async {
                viewModel.comparisonNutData = [queryResult1, queryResult2]
            }
        }
    }
    
    private func initializeDatabase() {
        if databasePointer == nil {
            databasePointer = CA_DatabaseHelper.getDatabasePointer(databaseName: "CSIDAssistPlusFoodDatabase.db")
        }
    }

}

#Preview {
    HomeScreen()
        .environmentObject(SessionViewModel())
}
