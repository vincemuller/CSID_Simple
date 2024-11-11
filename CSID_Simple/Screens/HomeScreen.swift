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
                        ZStack (alignment: .leading) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.textField)
                                .frame(width: 300, height: 40)
                            HStack {
                                Image(systemName:  search != .isNotFocused ? "arrow.left" :  "magnifyingglass")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(Color(UIColor.label).opacity(0.6))
                                    .onTapGesture {
                                        if search != .isNotFocused {
                                            resetSearch()
                                        }
                                    }
                                ZStack (alignment: .leading) {
                                    searchText.count > 0 ? nil : SearchCarouselView()
                                    TextField("", text: $searchText)
                                        .foregroundColor(Color(UIColor.label))
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
                                        ListsSectionView()
                                    }
                                } header: {
                                    Text(section.label)
                                        .font(.system(size: 30, weight: .semibold))
                                        .foregroundStyle(Color(UIColor.label))
                                }
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 7, leading: 15, bottom: 0, trailing: 15))
                        }
                        .listStyle(.plain)
                    case .isFocused:
                        SearchFiltersView(selectedFilter: $selectedFilter, searchText: searchText, searchFoods: searchFoods)
                        
                        SearchResultsView(isPresenting: $viewModel.foodDetalsPresenting, selectedFood: $viewModel.selectedFood, compareQueue: $viewModel.compareQueue, searchResults: searchResults, selectedSort: selectedSort)
                        
                        searchResults.isEmpty ? nil : Text(viewModel.compareQueue.count != 2 ? "\(searchResults.count) foods found" : "Compare Foods")
                            .font(.system(size: viewModel.compareQueue.count != 2 ? 14 : 18, weight: .semibold))
                            .foregroundStyle(viewModel.compareQueue.count != 2 ? Color(UIColor.label) : .iconTeal)
                            .frame(height: 25)
                            .offset(y: 12)
                            .onTapGesture {
                                if viewModel.compareQueue.count == 2 {
                                    viewModel.compareFoodsSheetPresenting = true
                                }
                            }

                    case .searchInProgress:
                        VStack {
                            Image("csidAssistLogo")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundStyle(Color(UIColor.label).opacity(0.5))
                                .frame(width: 160, height: 160)
                        }.offset(y: 150)
                    }
                }
            }
        }
        .overlay(alignment: .topLeading, content: {
            Image("csidAssistLogo")
                .resizable()
                .frame(width: 70, height: 70)
                .safeAreaPadding(.top)
                .padding(.leading)
                .padding(.top, 20)
        })
        .ignoresSafeArea()
        .sheet(isPresented: $viewModel.compareFoodsSheetPresenting, onDismiss: {
            viewModel.compareFoodsSheetPresenting = false
        }) {
            ComparisonScreen(foods: viewModel.compareQueue)
        }
        .sheet(isPresented: $viewModel.foodDetalsPresenting, onDismiss: {
            viewModel.foodDetalsPresenting = false
        }) {
            FoodDetailsScreen(food: viewModel.selectedFood)
        }
        .onAppear(perform: {
            if databasePointer == nil {databasePointer = CA_DatabaseHelper.getDatabasePointer(databaseName: "CSIDAssistPlusFoodDatabase.db")
            }
        })
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
    
    func searchFoods() {
        searchResults = []
        search = .searchInProgress
        // Prepare search components
        let searchComponents = searchText.lowercased()
            .components(separatedBy: " ")
            .filter { !$0.isEmpty }
        
        // Configure whole food filter
        let wF = selectedFilter == .wholeFoods ? "USDAFoodSearchTable.wholeFood='yes' AND" :
                 selectedFilter == .brandedFoods ? "USDAFoodSearchTable.wholeFood='no' AND" : ""
        
        // Construct search terms
        let searchTerms = searchComponents
            .map { "USDAFoodSearchTable.searchKeyWords LIKE '%\($0)%'" }
            .joined(separator: " AND ")
        
        var fullSearchTerms = "\(wF) \(searchTerms)"
        
        // Set sorting filter based on label
        let sortFilter: String
        switch selectedSort {
        case "Relevance":
            sortFilter = "wholeFood DESC, length(description)"
        case "Sugars (Low to High)":
            fullSearchTerms += " AND USDAFoodSearchTable.totalSugars IS NOT NULL"
            sortFilter = "CAST(totalSugars AS REAL)"
        case "Sugars (High to Low)":
            fullSearchTerms += " AND USDAFoodSearchTable.totalSugars IS NOT NULL"
            sortFilter = "CAST(totalSugars AS REAL) DESC"
        case "Starches (Low to High)":
            fullSearchTerms += " AND USDAFoodSearchTable.totalStarches IS NOT NULL"
            sortFilter = "CAST(totalStarches AS REAL)"
        case "Starches (High to Low)":
            fullSearchTerms += " AND USDAFoodSearchTable.totalStarches IS NOT NULL"
            sortFilter = "CAST(totalStarches AS REAL) DESC"
        case "Carbs (Low to High)":
            fullSearchTerms += " AND USDAFoodSearchTable.carbs IS NOT NULL"
            sortFilter = "CAST(carbs AS REAL)"
        case "Carbs (High to Low)":
            fullSearchTerms += " AND USDAFoodSearchTable.carbs IS NOT NULL"
            sortFilter = "CAST(carbs AS REAL) DESC"
        default:
            sortFilter = "wholeFood DESC, length(description)"
        }
        // Perform database query on a background queue
        DispatchQueue(label: "search.serial.queue").async {
            let queryResult = DatabaseQueries.databaseSearch(
                searchTerms: fullSearchTerms,
                databasePointer: databasePointer,
                sortFilter: sortFilter
            )
            
            // Update UI on main queue
            DispatchQueue.main.async {
                self.searchResults = queryResult
                search = .isFocused
            }
        }
    }

}

#Preview {
    HomeScreen()
}

struct ListsSectionView: View {
    
    private var savedListMockData = ["Safe Foods","Unsafe Foods","Favorite Snacks","Favorite Treats"]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(.textField)
                .frame(width: 350, height: 175)
            List(savedListMockData, id: \.self) {list in
                Section {
                    if savedListMockData.firstIndex(of: list) == 0 {
                        HStack {
                            Group {
                                Image(systemName: "plus")
                                    .foregroundStyle(.iconTeal)
                            }
                            Text("Create New List")
                                .font(.system(size: 16))
                                .foregroundStyle(.iconTeal)
                        }
                    }
                    HStack {
                        Image(systemName: "bookmark")
                        Text(list)
                            .font(.system(size: 16))
                    }
                }
                .listRowBackground(Color.clear)
            }
            .scrollIndicators(.hidden)
            .padding(.trailing)
        }
    }
}
