//
//  ContentView.swift
//  CSID_Simple
//
//  Created by Vince Muller on 10/29/24.
//

import SwiftUI


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
    
    private let searchFilters: [SearchFilter] = SearchFilter.allCases

    
    var body: some View {
        
        NavigationStack {
            ZStack (alignment: .top) {
                BackgroundView()
                    .navigationTitle("CSIDAssist")
                VStack (spacing: 0) {
                    HStack (spacing: 10) {
//                        SearchBarView(searchText: $searchText, isFocused: $isFocused, searchState: $search, resetSearch: resetSearch, searchFoods: searchFoods)
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
                        SortResultsView(selectedSort: $selectedSort)
                            .onChange(of: selectedSort) {
                                search == .isFocused ? searchFoods() : nil
                            }
                    }
                .padding(.top, 5)
                    switch search {
                    case .isNotFocused:
                        ForEach(HomeScreenSections.allCases) {section in
                            if section == .activity {
                                Text(section.label)
                                    .font(.system(size: 25, weight: .semibold))
                                    .foregroundStyle(.white)
                                    .frame(width: 350, alignment: .leading)
                                    .padding(.vertical, 10)
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
                            } else if section == .meals {
                                Text(section.label)
                                    .font(.system(size: 25, weight: .semibold))
                                    .foregroundStyle(.white)
                                    .frame(width: 350, alignment: .leading)
                                    .padding(.vertical, 10)
//                                MealTypeSectionView()
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(.textField)
                                        .frame(width: 350, height: 100)
                                    LazyVGrid(columns: [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())], content: {
                                        ForEach(MealType.allCases, id: \.id) { meal in
                                            if  !meal.label.contains("Snack") {
                                                NavigationLink(destination: MealLoggingScreen(mealType: meal)) {
                                                    VStack (spacing: 5) {
                                                        Image(meal.label.lowercased())
                                                            .resizable()
                                                            .frame(width: 55, height: 55)
                                                            .mask {
                                                                Circle()
                                                                    .frame(width: 50, height: 50)
                                                            }
                                                        Text(meal.label)
                                                            .font(.system(size: 12, weight: .semibold))
                                                            .foregroundStyle(.white)
                                                    }
                                                }
                                            }
                                        }
                                        Menu {
                                            NavigationLink(destination: MealLoggingScreen(mealType: .eveningSnack)) {
                                                Text("Evening Snack")
                                            }
                                            NavigationLink(destination: MealLoggingScreen(mealType: .afternoonSnack)) {
                                                Text("Afternoon Snack")
                                            }
                                            NavigationLink(destination: MealLoggingScreen(mealType: .morningSnack)) {
                                                Text("Morning Snack")
                                            }
                                        } label: {
                                            VStack (spacing: 5) {
                                                Image("snack")
                                                    .resizable()
                                                    .frame(width: 55, height: 55)
                                                    .mask {
                                                        Circle()
                                                            .frame(width: 50, height: 50)
                                                    }
                                                Text("Snack")
                                                    .font(.system(size: 12, weight: .semibold))
                                                    .foregroundStyle(.white)
                                            }
                                        }
                                    }).frame(width: 300, alignment: .center)
                                }
                            } else {
                                Text(section.label)
                                    .font(.system(size: 25, weight: .semibold))
                                    .foregroundStyle(.white)
                                    .frame(width: 350, alignment: .leading)
                                    .padding(.vertical, 10)
//                                SavedListsView(savedLists: $user.userSavedLists , createListScreenPresenting: $viewModel.createListScreenPresenting)
                                ZStack (alignment: .top) {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(.textField)
                                        .frame(width: 350, height: 170)
                                    ScrollView {
                                        VStack (alignment: .leading, spacing: 10) {
                                            ForEach(user.userSavedLists, id: \.id) { list in
                                                if user.userSavedLists.firstIndex(of: list) == 0 {
                                                    HStack {
                                                        Group {
                                                            Image(systemName: "plus")
                                                                .foregroundStyle(.iconTeal)
                                                        }
                                                        Text("Create New List")
                                                            .font(.system(size: 16))
                                                            .foregroundStyle(.iconTeal)
                                                    }.onTapGesture {
                                                        viewModel.createListScreenPresenting = true
                                                    }
                                                    Divider()
                                                        .padding(.leading, 25)
                                                }
                                                NavigationLink(destination: SavedListSearchScreen(list: list)) {
                                                    HStack {
                                                        Image(systemName: "bookmark")
                                                            .foregroundStyle(.white)
                                                        Text(list.name ?? "")
                                                            .foregroundStyle(.white)
                                                            .font(.system(size: 16))
                                                    }
                                                }
                                                Divider()
                                                    .padding(.leading, 25)
                                            }
                                        }
                                        .padding()
                                    }
                                    .frame(width: 350, height: 165, alignment: .leading)
                                }
                            }
                        }
                    case .isFocused:
//                        SearchFiltersView(selectedFilter: $selectedFilter, searchText: searchText, searchFoods: searchFoods)
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
                        
//                        SearchResultsView(isPresenting: $viewModel.foodDetalsPresenting, selectedFood: $viewModel.selectedFood, compareQueue: $viewModel.compareQueue, searchResults: $searchResults, selectedSort: selectedSort)
                        ScrollView {
                            LazyVGrid (columns: [GridItem(.flexible())], spacing: 5) {
                                ForEach(searchResults, id: \.self) {food in
                                    SearchResultCellView(isPresenting: $viewModel.foodDetalsPresenting, selectedFood: $viewModel.selectedFood, compareQueue: $viewModel.compareQueue, result: food, selectedSort: selectedSort)
                                }.padding(.bottom, 5)
                            }
                        }
                        
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
            FoodDetailsScreen(food: $viewModel.selectedFood)
        }
        .sheet(isPresented: $viewModel.createListScreenPresenting, onDismiss: {
            viewModel.createListScreenPresenting = false
        }) {
            CreateListScreen()
        }
        .onAppear(perform: initializeDatabase)
        .onAppear(perform: {
            Task {
//                await viewModel.getSavedLists()
//                await viewModel.getSavedFoods()
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
