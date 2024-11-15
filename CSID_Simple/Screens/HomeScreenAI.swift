////
////  HomeScreenAI.swift
////  CSID_Simple
////
////  Created by Vince Muller on 11/12/24.
////
//
//import SwiftUI
//
//enum HomeScreenSections: Identifiable, CaseIterable {
//    case activity, meals, lists
//    
//    var id: Self { self }
//    
//    var label: String {
//        switch self {
//        case .activity: return "Activity"
//        case .meals: return "Meals"
//        case .lists: return "Lists"
//        }
//    }
//}
//
//enum SearchState: CaseIterable {
//    case isNotFocused, isFocused, searchInProgress
//}
//
//enum SearchFilter: Identifiable, CaseIterable {
//    case wholeFoods, allFoods, brandedFoods
//    
//    var id: Self { self }
//    var label: String {
//        switch self {
//        case .wholeFoods: return "Whole Foods"
//        case .allFoods: return "All Foods"
//        case .brandedFoods: return "Branded Foods"
//        }
//    }
//}
//
//struct HomeScreenAI: View {
//    @FocusState private var isFocused: Bool
//    @StateObject private var viewModel = ViewModel()
//    @State private var sections: HomeScreenSections = .activity
//    @State private var searchState: SearchState = .isNotFocused
//    @State private var searchText: String = ""
//    @State private var selectedSort: String = "Relevance"
//    @State private var selectedFilter: SearchFilter = .allFoods
//    @State private var searchResults: [FoodDetails] = []
//    
//    var body: some View {
//        NavigationStack {
//            ZStack(alignment: .top) {
//                BackgroundView()
//                    .navigationTitle("CSIDAssist")
//                
//                VStack(spacing: 0) {
//                    HStack (spacing: 10) {
//                        SearchBarView(searchText: $searchText, isFocused: $isFocused, searchState: $searchState, resetSearch: resetSearch, searchFoods: searchFoods)
//                        SortResultsView(selectedSort: $selectedSort)
//                            .onChange(of: selectedSort) {
//                                searchState == .isFocused ? searchFoods() : nil
//                            }
//                    }
//                    .padding(.top, 10)
//                    
//                    contentForCurrentState
//                }
//            }
//        }
//        .overlay(topLeadingLogo)
//        .ignoresSafeArea()
//        .sheet(isPresented: $viewModel.compareFoodsSheetPresenting) {
//            ComparisonScreen(foods: viewModel.compareQueue, nutrition: $viewModel.comparisonNutData)
//        }
//        .sheet(isPresented: $viewModel.foodDetalsPresenting) {
//            FoodDetailsScreen(food: viewModel.selectedFood)
//        }
//        .onAppear(perform: initializeDatabase)
//        .onChange(of: viewModel.compareQueue) { _ in
//            if viewModel.compareQueue.count == 2 {
//                getComparisonNutDetails()
//            }
//        }
//    }
//    
//    @ViewBuilder
//    private var contentForCurrentState: some View {
//        switch searchState {
//        case .isNotFocused:
////            SectionedListView(sections: HomeScreenSections.allCases)
//            List {
//                ForEach(HomeScreenSections.allCases) {section in
//                    Section {
//                        if section == .activity {
//                            RoundedRectangle(cornerRadius: 15)
//                                .fill(.textField)
//                                .frame(width: 350, height: 100)
//                        } else if section == .meals {
//                            MealTypeSectionView()
//                        } else {
//                            SavedListsView()
//                        }
//                    } header: {
//                        Text(section.label)
//                            .font(.system(size: 30, weight: .semibold))
//                            .foregroundStyle(Color(UIColor.label))
//                    }
//                }
//                .listRowBackground(Color.clear)
//                .listRowSeparator(.hidden)
//                .listRowInsets(EdgeInsets(top: 7, leading: 18, bottom: 0, trailing: 15))
//            }
//             .listStyle(.plain)
//        case .isFocused:
////            SearchFocusedView(
////                selectedFilter: $selectedFilter,
////                searchText: searchText,
////                searchFoods: searchFoods,
////                searchResults: searchResults,
////                viewModel: viewModel
////            )
//            SearchFiltersView(selectedFilter: $selectedFilter, searchText: searchText, searchFoods: searchFoods)
//            
//            SearchResultsView(isPresenting: $viewModel.foodDetalsPresenting, selectedFood: $viewModel.selectedFood, compareQueue: $viewModel.compareQueue, searchResults: searchResults, selectedSort: selectedSort)
//            
//            searchResults.isEmpty ? nil : Text(viewModel.compareQueue.count != 2 ? "\(searchResults.count) foods found" : "Compare Foods")
//                .font(.system(size: viewModel.compareQueue.count != 2 ? 14 : 18, weight: .semibold))
//                .foregroundStyle(viewModel.compareQueue.count != 2 ? Color(UIColor.label) : .iconTeal)
//                .frame(height: 25)
//                .offset(y: 12)
//                .onTapGesture {
//                    if viewModel.compareQueue.count == 2 {
//                        viewModel.compareFoodsSheetPresenting = true
//                    }
//                }
//        case .searchInProgress:
////            ProgressIndicator()
//            VStack {
//                Image("csidAssistLogo")
//                    .resizable()
//                    .renderingMode(.template)
//                    .foregroundStyle(Color(UIColor.label).opacity(0.5))
//                    .frame(width: 160, height: 160)
//            }.offset(y: 150)
//        }
//    }
//    
//    private var topLeadingLogo: some View {
//        Image("csidAssistLogo")
//            .resizable()
//            .frame(width: 70, height: 70)
//            .safeAreaPadding(.top)
//            .padding(.leading)
//            .padding(.top, 20)
//    }
//    
//    private func resetSearch() {
//        isFocused = false
//        searchText = ""
//        searchResults = []
//        searchState = .isNotFocused
//        selectedSort = "Relevance"
//        selectedFilter = .allFoods
//        viewModel.compareQueue = []
//    }
//    
//    private func searchFoods() {
//        searchState = .searchInProgress
//        DispatchQueue(label: "search.serial.queue").async {
//            let queryResult = DatabaseQueries.databaseSearch(
//                searchTerms: buildSearchTerms(),
//                databasePointer: databasePointer,
//                sortFilter: getSortFilter()
//            )
//            DispatchQueue.main.async {
//                self.searchResults = queryResult
//                searchState = .isFocused
//            }
//        }
//    }
//    
//    private func buildSearchTerms() -> String {
//        let searchComponents = searchText.lowercased().components(separatedBy: " ").filter { !$0.isEmpty }
//        let filterClause = selectedFilter == .wholeFoods ? "USDAFoodSearchTable.wholeFood='yes' AND" :
//                           selectedFilter == .brandedFoods ? "USDAFoodSearchTable.wholeFood='no' AND" : ""
//        
//        return "\(filterClause) \(searchComponents.map { "USDAFoodSearchTable.searchKeyWords LIKE '%\($0)%'" }.joined(separator: " AND "))"
//    }
//    
//    private func getSortFilter() -> String {
//        switch selectedSort {
//        case "Relevance": return "wholeFood DESC, length(description)"
//        case "Sugars (Low to High)": return "CAST(totalSugars AS REAL)"
//        case "Sugars (High to Low)": return "CAST(totalSugars AS REAL) DESC"
//        case "Starches (Low to High)": return "CAST(totalStarches AS REAL)"
//        case "Starches (High to Low)": return "CAST(totalStarches AS REAL) DESC"
//        case "Carbs (Low to High)": return "CAST(carbs AS REAL)"
//        case "Carbs (High to Low)": return "CAST(carbs AS REAL) DESC"
//        default: return "wholeFood DESC, length(description)"
//        }
//    }
//    
//    private func getComparisonNutDetails() {
//        DispatchQueue(label: "nutrition.serial.queue").async {
//            let queryResult1 = DatabaseQueries.getNutrientData(fdicID: viewModel.compareQueue[0].fdicID, databasePointer: databasePointer)
//            let queryResult2 = DatabaseQueries.getNutrientData(fdicID: viewModel.compareQueue[1].fdicID, databasePointer: databasePointer)
//            
//            DispatchQueue.main.async {
//                viewModel.comparisonNutData = [queryResult1, queryResult2]
//            }
//        }
//    }
//    
//    private func initializeDatabase() {
//        if databasePointer == nil {
//            databasePointer = CA_DatabaseHelper.getDatabasePointer(databaseName: "CSIDAssistPlusFoodDatabase.db")
//        }
//    }
//}
//
//#Preview {
//    HomeScreenAI()
//}
//
