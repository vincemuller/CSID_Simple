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
    case unfocused, focused, inProgress
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
    
    @State private var sections: HomeScreenSections = .activity
    @State private var search: Search = .unfocused
    @State private var searchText: String = ""
    @State private var selectedSort: String = "Relevance"
    @State private var selectedFilter: SearchFilter = .allFoods
    @State private var searchResults: [FoodDetails] = []
    @State private var activeSearch: Bool = false
    
    private let searchFilters: [SearchFilter] = SearchFilter.allCases
    private var sortingOptions = ["Relevance",
                                  "Carbs (Low to High)",
                                  "Carbs (High to Low)",
                                  "Sugars (Low to High)",
                                  "Sugars (High to Low)",
                                  "Starches (Low to High)",
                                  "Starches (High to Low)"]
    
    private var savedListMockData = ["Safe Foods","Unsafe Foods","Favorite Snacks","Favorite Treats"]
    
    var body: some View {
        
        NavigationStack {
            ZStack (alignment: .top) {
                LinearGradient(colors: [.backgroundColor1,.backgroundColor2,.backgroundColor1], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                    .navigationTitle("CSIDAssist")
                VStack (spacing: 0) {
                    HStack (spacing: 10) {
                        ZStack (alignment: .leading) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.textField)
                                .frame(width: 300, height: 40)
                            HStack {
                                Image(systemName:  search != .unfocused ? "arrow.left" :  "magnifyingglass")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(Color(UIColor.label).opacity(0.6))
                                    .onTapGesture {
                                        if search != .unfocused {
                                            isFocused = false
                                            searchText = ""
                                            searchResults = []
                                            search = .unfocused
                                            selectedSort = "Relevance"
                                            selectedFilter = .allFoods
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
                                                search = .focused
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
                                    .foregroundColor(Color(UIColor.label))
                            }
                        }
                        .onChange(of: selectedSort) {
                            search == .focused ? searchFoods() : nil
                        }
                    }
                    .padding(.top, 10)
                    
                    switch search {
                    case .unfocused:
                        List {
                            ForEach(HomeScreenSections.allCases) {section in
                                Section {
                                    if section == .activity {
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(.textField)
                                            .frame(width: 350, height: 100)
                                    } else if section == .meals {
                                        MealTypeIconView()
                                    } else {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 15)
                                                .fill(.textField)
                                                .frame(width: 350, height: 170)
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
                                                }                                          .listRowBackground(Color.clear)
                                            }
                                            .scrollIndicators(.hidden)
                                            .padding(.trailing)
                                        }
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
                    case .focused:
                        LazyVGrid(columns: [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]) {
                            ForEach(searchFilters, id: \.self) { filter in
                                Button(action: {selectedFilter = filter; searchFoods()}, label: {
                                    Text(filter.selected)
                                        .font(.system(size: 13, weight: selectedFilter.selected == filter.selected ? .bold : .semibold))
                                        .foregroundStyle( selectedFilter.selected == filter.selected ? Color(UIColor.label) :
                                                            Color(UIColor.label).opacity(0.3))
                                })
                                .background(
                                    RoundedRectangle(cornerRadius: 7)
                                        .fill(.clear)
                                        .stroke(selectedFilter.selected == filter.selected ? Color(UIColor.label) : Color(UIColor.label).opacity(0.3), lineWidth: selectedFilter.selected == filter.selected ? 2 : 1)
                                        .frame(width: 105, height: 30))
                            }
                        }.padding(.horizontal, 25).padding(.vertical, 20)
                        
                        ScrollView {
                            LazyVGrid (columns: [GridItem(.flexible())], spacing: 3) {
                                ForEach(searchResults, id: \.self) {food in
                                    SearchResultCellView(result: food)
                                }.padding(.bottom, 5)
                            }.padding(.top)
                        }
                    case .inProgress:
                        Text("Search In Progress")
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
        .onAppear(perform: {
            if databasePointer == nil {databasePointer = CA_DatabaseHelper.getDatabasePointer(databaseName: "CSIDAssistPlusFoodDatabase.db")
            }
        })
    }
    
    func searchFoods() {
        searchResults = []
        search = .inProgress
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
        
        let fullSearchTerms = "\(wF) \(searchTerms)"
        
        // Set sorting filter based on label
        let sortFilter: String
        switch selectedSort {
        case "Relevance":
            sortFilter = "wholeFood DESC, length(description)"
        case "Sugars (Low to High)":
            sortFilter = "CAST(totalSugars AS REAL)"
        case "Sugars (High to Low)":
            sortFilter = "CAST(totalSugars AS REAL) DESC"
        case "Starches (Low to High)":
            sortFilter = "CAST(totalStarches AS REAL)"
        case "Starches (High to Low)":
            sortFilter = "CAST(totalStarches AS REAL) DESC"
        case "Carbs (Low to High)":
            sortFilter = "CAST(carbs AS REAL)"
        case "Carbs (High to Low)":
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
                search = .focused
            }
        }
    }

}

#Preview {
    HomeScreen()
}

struct MealTypeIconView: View {
    
    private var meals: [String] = ["Breakfast","Lunch","Dinner","Snack"]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(.textField)
                .frame(width: 350, height: 100)
            LazyVGrid(columns: [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())], content: {
                ForEach(meals, id: \.self) { meal in
                    VStack (spacing: 5) {
                        Image(meal.lowercased())
                            .resizable()
                            .frame(width: 55, height: 55)
                            .mask {
                                Circle()
                                    .frame(width: 50, height: 50)
                            }
                        Text(meal)
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .onTapGesture {
                        print(meal)
                    }
                }
            }).frame(width: 300, alignment: .center)
        }
    }
}
