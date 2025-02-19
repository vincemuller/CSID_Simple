//
//  ContentView.swift
//  CSID_Simple
//
//  Created by Vince Muller on 10/29/24.
//

import SwiftUI
import Amplify
import AWSPluginsCore
import AWSAPIPlugin


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
    @EnvironmentObject var user: User
    //Title foreground color
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
//    //User singleton
//    @State private var user = User.shared
    
    //Search focus state
    @FocusState private var isFocused: Bool
    
    //Search variables
    @State private var search: Search = .isNotFocused
    @State private var searchText: String = ""
    @State private var selectedSort: String = "Relevance"
    @State private var selectedFilter: SearchFilter = .allFoods
    @State private var searchResults: [FoodDetails] = []
    @State private var activeSearch: Bool = false
    private let searchFilters: [SearchFilter] = SearchFilter.allCases
    private let sortingOptions = ["Relevance",
                                  "Carbs (Low to High)",
                                  "Carbs (High to Low)",
                                  "Sugars (Low to High)",
                                  "Sugars (High to Low)",
                                  "Starches (Low to High)",
                                  "Starches (High to Low)"]
    
    //Compare foods variables
    @State private var compareFoodsSheetPresenting: Bool = false
    @State private var compareQueue: [FoodDetails] = []
    @State private var comparisonNutData: [NutrientData] = []
    
    //Food details variables
    @State private var selectedFood: FoodDetails = FoodDetails(searchKeyWords: "", fdicID: 0, brandedFoodCategory: "", description: "", servingSize: 0, servingSizeUnit: "", carbs: "", totalSugars: "", totalStarches: "", wholeFood: "")
    @State private var foodDetalsPresenting: Bool = false
    
    //New Date and Week Variables
    @State private var calendar = Calendar.current
    @State private var dates: [Date] = []
    
    //Daily totals variables
    @State private var dashboardWeek: Date = Date().getNormalizedDate(adjustor: -3)
    @State private var selectedDay: Date = Date().getNormalizedDate(adjustor: 0)

    //Saved Lists variables
    @State private var createListScreenPresenting: Bool = false
    
    
    
    var body: some View {
        NavigationStack {
            ZStack (alignment: .top) {
                BackgroundView()
                    .navigationTitle("CSIDAssist")
                
                //Search bar section with sorting options
                VStack (spacing: 0) {
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
                    .padding(.vertical, 5)
                    switch search {
                    case .isNotFocused:
                        ForEach(HomeScreenSections.allCases) {section in
                            
                            //User logged meals data section
                            if section == .mealData {
                                SectionTitleView(label: section.label)
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
                                                        selectedDay = Calendar.current.date(byAdding: .day, value: 6, to: dashboardWeek)!
                                                        Task {
                                                            await user.getUserMeals(selectedDay: selectedDay)
                                                        }
                                                    }
                                                    .padding(.leading, 10)
                                                ForEach(dates, id: \.self) {day in
                                                    let weekDay = day.formatted(.dateTime.weekday())
                                                    let calendarDay = day.formatted(.dateTime.day(.twoDigits))
                                                    let sD = selectedDay.formatted(.dateTime.weekday()) == weekDay
                                                    
                                                    ZStack {
                                                        sD ?
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .stroke(.white, lineWidth: 1.5)
                                                            .frame(width: 40, height: 45)
                                                        : nil
                                                        VStack {
                                                            StandardTextView(label: calendarDay, size: 12, weight: .medium)
                                                            StandardTextView(label: weekDay.uppercased(), size: 12, weight: .medium, textColor: .iconTeal)
                                                        }
                                                        .onTapGesture {
                                                            selectedDay = day
                                                            print(selectedDay.formatted())
                                                        }
                                                    }
                                                }
                                                Image(systemName: "chevron.right")
                                                    .foregroundStyle(.white)
                                                    .font(.system(size: 14, weight: .semibold))
                                                    .onTapGesture {
                                                        dashboardWeek = Calendar.current.date(byAdding: .day, value: 7, to: dashboardWeek)!
                                                        selectedDay = dashboardWeek
                                                        Task {
                                                            await user.getUserMeals(selectedDay: selectedDay.addingTimeInterval(.days(6)))
                                                        }
                                                    }
                                                    .padding(.trailing, 10)
                                            }
                                        }
                                        .padding(.top, 10)
                                        HStack (spacing: 0) {
                                            VStack (spacing: 0) {
                                                ZStack {
                                                    ConsumptionCircle(ringWidth: 40, percent: user.sugarsPercentage, backgroundColor: .iconRed.opacity(0.2), foregroundColors: [.iconRed.opacity(0.5), .iconRed, Color(UIColor.systemRed)])
                                                        .padding(10)
                                                    StandardTextView(label: "50g", size: 18)
                                                }
                                                StandardTextView(label: "Sugars", size: 14)
                                            }
                                            VStack (spacing: 0) {
                                                ZStack {
                                                    ConsumptionCircle(ringWidth: 40, percent: user.carbPercentage, backgroundColor: .iconTeal.opacity(0.2), foregroundColors: [.iconTeal.opacity(0.5), .iconTeal, Color(UIColor.systemGreen)])
                                                        .padding(10)
                                                    StandardTextView(label: "110g", size: 18)
                                                }
                                                StandardTextView(label: "Carbs", size: 14)
                                            }
                                            VStack (spacing: 0) {
                                                ZStack {
                                                    ConsumptionCircle(ringWidth: 40, percent: user.starchesPercentage, backgroundColor: .iconOrange.opacity(0.2), foregroundColors: [.iconOrange.opacity(0.5), .iconOrange, Color(UIColor.systemYellow)])
                                                        .padding(10)
                                                    StandardTextView(label: "60g", size: 18)
                                                }
                                                StandardTextView(label: "Starches", size: 14)
                                            }
                                        }.padding(.bottom)
                                    }
                                }
                                .frame(width: 350, height: 200)
                            } else if section == .meals {
                                
                                //Meal type section
                                SectionTitleView(label: section.label)
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(.textField)
                                        .frame(width: 350, height: 100)
                                    LazyVGrid(columns: [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())], content: {
                                        ForEach(MealType.allCases, id: \.id) { meal in
                                            if  !meal.label.contains("Snack") {
                                                NavigationLink(destination: getDestination(mealType: meal)) {
                                                    VStack (spacing: 5) {
                                                        Image(meal.label.lowercased())
                                                            .resizable()
                                                            .frame(width: 55, height: 55)
                                                            .mask {
                                                                Circle()
                                                                    .frame(width: 50, height: 50)
                                                            }
                                                        StandardTextView(label: meal.label, size: 12, weight: .semibold)
                                                    }
                                                }
                                            }
                                        }
                                        Menu {
                                            NavigationLink(destination: getDestination(mealType: MealType.eveningSnack)) {
                                                Text("Evening Snack")
                                            }
                                            NavigationLink(destination: getDestination(mealType: MealType.afternoonSnack)) {
                                                Text("Afternoon Snack")
                                            }
                                            NavigationLink(destination: getDestination(mealType: MealType.morningSnack)) {
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
                                                StandardTextView(label: "Snack", size: 12, weight: .semibold)
                                            }
                                        }
                                    }).frame(width: 300, alignment: .center)
                                }
                            } else {
                                
                                //User saved lists section
                                SectionTitleView(label: section.label)
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
                                                        StandardTextView(label: "Create New List", size: 16, textColor: .iconTeal)
                                                    }.onTapGesture {
                                                        createListScreenPresenting = true
                                                    }
                                                    Divider()
                                                        .padding(.leading, 25)
                                                }
                                                NavigationLink(destination: SavedListSearchScreen(list: list)) {
                                                    HStack {
                                                        Image(systemName: "bookmark")
                                                            .foregroundStyle(.white)
                                                        StandardTextView(label: list.name ?? "", size: 16)
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
                        
                        //Search filters for Whole Foods, Branded Foods, and All Foods
                        LazyVGrid(columns: [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]) {
                            ForEach(searchFilters, id: \.self) { filter in
                                Button(action: {selectedFilter = filter; searchText.isEmpty ? nil : searchFoods()}, label: {
                                    StandardTextView(label: filter.selected, size: 13, weight: selectedFilter.selected == filter.selected ? .bold : .semibold, textColor: selectedFilter.selected == filter.selected ? .white :
                                            .white.opacity(0.3))
                                })
                                .background(
                                    RoundedRectangle(cornerRadius: 7)
                                        .fill(.clear)
                                        .stroke(selectedFilter.selected == filter.selected ? .white : .white.opacity(0.3), lineWidth: selectedFilter.selected == filter.selected ? 2 : 1)
                                        .frame(width: 105, height: 30))
                            }
                        }.padding(.horizontal, 25).padding(.vertical, 20)
                        
                        //Search results view
                        ScrollView {
                            LazyVGrid (columns: [GridItem(.flexible())], spacing: 5) {
                                ForEach(searchResults, id: \.self) {food in
                                    SearchResultCellView(isPresenting: $foodDetalsPresenting, selectedFood: $selectedFood, compareQueue: $compareQueue, result: food, selectedSort: selectedSort)
                                }.padding(.bottom, 5)
                            }
                        }
                        
                        //Search results totals and compare foods options
                        searchResults.isEmpty ? nil :
                        HStack (spacing: 10) {
                            compareQueue.count == 2 ? nil :
                            StandardTextView(label: "\(searchResults.count) foods found", size: 14, weight: .semibold)
                            compareQueue.count != 2 ? nil :
                            Button(action: {
                                compareQueue = []
                            }, label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 7)
                                        .stroke(.iconOrange)
                                        .frame(width: 120, height: 30)
                                    StandardTextView(label: "Clear Foods", size: 14, weight: .semibold, textColor: .iconOrange)
                                }
                            })
                            
                            compareQueue.count != 2 ? nil :
                            Button(action: {
                                if compareQueue.count == 2 {
                                    compareFoodsSheetPresenting = true
                                }
                            }, label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 7)
                                        .stroke(.iconTeal)
                                        .frame(width: 120, height: 30)
                                    StandardTextView(label: "Compare Foods", size: 14, weight: .semibold, textColor: .iconTeal)
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
        .sheet(isPresented: $compareFoodsSheetPresenting, onDismiss: {
            compareFoodsSheetPresenting = false
        }) {
            ComparisonScreen(foods: compareQueue, nutrition: $comparisonNutData)
        }
        .sheet(isPresented: $foodDetalsPresenting, onDismiss: {
            foodDetalsPresenting = false
        }) {
            FoodDetailsScreen(food: $selectedFood)
        }
        .sheet(isPresented: $createListScreenPresenting, onDismiss: {
            createListScreenPresenting = false
        }) {
            CreateListScreen()
        }
        .onAppear(perform: initializeDatabase)
        .onAppear(perform: {
            let today = calendar.startOfDay(for: Date())
            let dayOfWeek = calendar.component(.weekday, from: today)
            dates = calendar.range(of: .weekday, in: .weekOfYear, for: today)!.compactMap({calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: today)})
            print(user.carbPercentage)
            print(user.sugarsPercentage)
            print(user.starchesPercentage)
        })
        .onChange(of: compareQueue) {
            if compareQueue.count == 2 {
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
    
    @ViewBuilder
    private func getDestination(mealType: MealType) -> some View {
        if user.dailyMealCheck(selectedDay: selectedDay, mealType: mealType.label) {
            MealFoodListScreen(mealType: mealType, selectedDay: selectedDay)
        } else {
            FindMealFoodsScreen(mealType: mealType, selectedDay: selectedDay)
        }
    }
    
    func resetSearch() {
        isFocused = false
        searchText = ""
        searchResults = []
        search = .isNotFocused
        selectedSort = "Relevance"
        selectedFilter = .allFoods
        compareQueue = []

        if selectedDay.formatted(.dateTime.month().day().year()) != Date.now.formatted(.dateTime.month().day().year()) {
            dashboardWeek = Date.now.addingTimeInterval(.days(-3))
            selectedDay = Date.now
            Task {
                await user.getUserMeals(selectedDay: selectedDay)
            }
        }
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
            let queryResult1 = DatabaseQueries.getNutrientData(fdicID: compareQueue[0].fdicID, databasePointer: databasePointer)
            let queryResult2 = DatabaseQueries.getNutrientData(fdicID: compareQueue[1].fdicID, databasePointer: databasePointer)
            
            DispatchQueue.main.async {
                comparisonNutData = [queryResult1, queryResult2]
            }
        }
    }
    
    private func initializeDatabase() {
        if databasePointer == nil {
            databasePointer = CA_DatabaseHelper.getDatabasePointer(databaseName: "CSIDAssistPlusFoodDatabase.db")
        }
    }
    
    func getSavedLists() async {
        let lists = SavedLists.keys
        let predicate = lists.userID == user.userID
        let request = GraphQLRequest<SavedLists>.list(SavedLists.self, where: predicate)
        do {
            let result = try await Amplify.API.query(request: request)
            switch result {
            case .success(let lists):
                print("Successfully retrieved saved lists: \(lists.count)")
                DispatchQueue.main.async {
                    user.userSavedLists.removeAll()
                }
                for l in lists {
                    DispatchQueue.main.async {
                        user.userSavedLists.append(l)
                    }
                }
            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
//                errorAlert = true
//                errorComment = error.errorDescription
            }
        } catch let error as APIError {
            print("Failed to query saved lists: ", error)
//            errorAlert = true
//            errorComment = error.errorDescription
        } catch {
            print("Unexpected error: \(error)")
//            errorAlert = true
//            errorComment = error.localizedDescription
        }
    }
    
    func getSavedFoods() async {
        let foods = SavedFoods.keys
        let predicate = foods.userID == user.userID
        let request = GraphQLRequest<SavedFoods>.list(SavedFoods.self, where: predicate)
        do {
            let result = try await Amplify.API.query(request: request)
            switch result {
            case .success(let foods):
                print("Successfully retrieved saved foods: \(foods.count)")
                DispatchQueue.main.async {
                    user.userSavedFoods.removeAll()
                }
                for l in foods {
                    DispatchQueue.main.async {
                        user.userSavedFoods.append(l)
                    }
                }
            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
//                errorAlert = true
//                errorComment = error.errorDescription
            }
        } catch let error as APIError {
            print("Failed to query saved foods: ", error)
//            errorAlert = true
//            errorComment = error.errorDescription
        } catch {
            print("Unexpected error: \(error)")
//            errorAlert = true
//            errorComment = error.localizedDescription
        }
    }

}

#Preview {
    HomeScreen()
}
