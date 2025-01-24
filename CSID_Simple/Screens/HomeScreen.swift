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
            return "Daily Totals"
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

let columns: [GridItem] = [GridItem(.flexible()),
                           GridItem(.flexible()),
                           GridItem(.flexible()),
                           GridItem(.flexible()),
                           GridItem(.flexible()),
                           GridItem(.flexible()),
                           GridItem(.flexible()),
                           GridItem(.flexible()),
                           GridItem(.flexible())]

struct HomeScreen: View {
    
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
    @State private var user = User.shared
    
    @State private var dashboardWeek: Date = Date.now
    @State private var selectedDay: Date = Date.now

    
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
                .padding(.top, 5)
                    switch search {
                    case .isNotFocused:
                        List {
                            ForEach(HomeScreenSections.allCases) {section in
                                Section {
                                    if section == .activity {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 15)
                                                .fill(.textField)
                                            VStack {
                                                HStack {
                                                    LazyVGrid(columns: columns) {
                                                        Image(systemName: "chevron.left")
                                                            .foregroundStyle(.white)
                                                            .font(.system(size: 14, weight: .semibold))
                                                            .onTapGesture {
                                                                dashboardWeek = Calendar.current.date(byAdding: .day, value: -7, to: dashboardWeek)!
                                                                selectedDay = Calendar.current.date(byAdding: .day, value: -4, to: dashboardWeek)!
                                                            }
                                                            .padding(.leading, 10)
                                                        ForEach((1...7), id: \.self) {day in
                                                            let d = Calendar.current.date(byAdding: .day, value: day-4, to: dashboardWeek)!
                                                            let weekDay = d.formatted(.dateTime.weekday())
                                                            let calendarDay = d.formatted(.dateTime.day(.twoDigits))
                                                            let sD = selectedDay.formatted(.dateTime.weekday()) == weekDay
                                                            
                                                            ZStack {
                                                                sD ?
                                                                RoundedRectangle(cornerRadius: 10)
                                                                    .stroke(.white, lineWidth: 1.5)
                                                                    .frame(width: 40, height: 45)
                                                                : nil
                                                                VStack {
                                                                    Text(calendarDay)
                                                                        .font(.system(size: 12, weight: .medium, design: .default))
                                                                        .foregroundStyle(.white)
                                                                    Text(weekDay.uppercased())
                                                                        .font(.system(size: 12, weight: .medium, design: .default))
                                                                        .foregroundStyle(.iconTeal)
                                                                }
                                                                .onTapGesture {
                                                                    selectedDay = d
                                                                    print(selectedDay.formatted())
                                                                }
                                                            }
                                                        }
                                                        Image(systemName: "chevron.right")
                                                            .foregroundStyle(.white)
                                                            .font(.system(size: 14, weight: .semibold))
                                                            .onTapGesture {
                                                                dashboardWeek = Calendar.current.date(byAdding: .day, value: 7, to: dashboardWeek)!
                                                                selectedDay = Calendar.current.date(byAdding: .day, value: 4, to: dashboardWeek)!
                                                            }
                                                            .padding(.trailing, 10)
                                                    }
                                                }
                                                .padding(.top, 10)
                                                HStack (spacing: 0) {
                                                    VStack (spacing: 0) {
                                                        ZStack {
                                                            ConsumptionCircle(ringWidth: 40, percent: 115, backgroundColor: .iconRed.opacity(0.2), foregroundColors: [.iconRed.opacity(0.5), .iconRed, Color(UIColor.systemRed)])
                                                                .padding(10)
                                                            Text("50g")
                                                                .font(.system(size: 18))
                                                                .foregroundStyle(.white)
                                                        }
                                                        Text("Sugars")
                                                            .font(.system(size: 14))
                                                            .foregroundStyle(.white)
                                                    }
                                                    VStack (spacing: 0) {
                                                        ZStack {
                                                            ConsumptionCircle(ringWidth: 40, percent: 75, backgroundColor: .iconTeal.opacity(0.2), foregroundColors: [.iconTeal.opacity(0.5), .iconTeal, Color(UIColor.systemGreen)])
                                                                .padding(10)
                                                            Text("110g")
                                                                .font(.system(size: 18))
                                                                .foregroundStyle(.white)
                                                        }
                                                        Text("Carbs")
                                                            .font(.system(size: 14))
                                                            .foregroundStyle(.white)
                                                    }
                                                    VStack (spacing: 0) {
                                                        ZStack {
                                                            ConsumptionCircle(ringWidth: 40, percent: 50, backgroundColor: .iconOrange.opacity(0.2), foregroundColors: [.iconOrange.opacity(0.5), .iconOrange, Color(UIColor.systemYellow)])
                                                                .padding(10)
                                                            Text("60g")
                                                                .font(.system(size: 18))
                                                                .foregroundStyle(.white)
                                                        }
                                                        Text("Starches")
                                                            .font(.system(size: 14))
                                                            .foregroundStyle(.white)
                                                    }
                                                }.padding(.bottom)
                                            }
                                        }
                                        .frame(width: 350, height: 200)
                                        .listRowInsets(EdgeInsets(top: 0, leading: 18, bottom: 0, trailing: 15))
                                    } else if section == .meals {
                                        MealTypeSectionView()
                                            .listRowInsets(EdgeInsets(top: 0, leading: 18, bottom: 0, trailing: 15))
                                    } else {
                                        SavedListsView(savedLists: $user.userSavedLists , createListScreenPresenting: $viewModel.createListScreenPresenting)
                                            .listRowInsets(EdgeInsets(top: 0, leading: 18, bottom: 0, trailing: 15))
                                    }
                                } header: {
                                    Text(section.label)
                                        .font(.system(size: 25, weight: .semibold))
                                        .foregroundStyle(.white)
                                        .listRowInsets(EdgeInsets(top: -10, leading: 18, bottom: 5, trailing: 15))
                                }
                            }
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                        }
                        .listStyle(.plain)
                    case .isFocused:
                        SearchFiltersView(selectedFilter: $selectedFilter, searchText: searchText, searchFoods: searchFoods)
                        
                        SearchResultsView(isPresenting: $viewModel.foodDetalsPresenting, selectedFood: $viewModel.selectedFood, compareQueue: $viewModel.compareQueue, searchResults: $searchResults, selectedSort: selectedSort)
                        
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
            .overlay(alignment: .topLeading, content: {
                topLeadingLogo
            })
        }
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
        .onAppear(perform: {
            Task {
                await viewModel.getSavedLists()
                await viewModel.getSavedFoods()
//                await User.shared.testMealLogging()
            }
        })
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
            .padding(.leading, 10)
            .padding(.top, 35)
            .ignoresSafeArea()
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
}
