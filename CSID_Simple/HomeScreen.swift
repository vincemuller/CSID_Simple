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
    case unfocused, focused, active
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
    @State private var searchResults: [FoodDetails] = [FoodDetails(searchKeyWords: "", fdicID: 0, brandOwner: "Mars Inc.", brandName: "M&M Mars", brandedFoodCategory: "Confectionary and Sweets", description: "Snickers Crunchers, Chocolate Candy Bar", servingSize: 80, servingSizeUnit: "g", carbs: "25", totalSugars: "12.5", totalStarches: "12.5", wholeFood: "no"),FoodDetails(searchKeyWords: "", fdicID: 0, brandOwner: "Mars Inc.", brandName: "M&M Mars", brandedFoodCategory: "Confectionary and Sweets", description: "Snickers Crunchers, Chocolate Candy Bar", servingSize: 80, servingSizeUnit: "g", carbs: "25", totalSugars: "12.5", totalStarches: "12.5", wholeFood: "no"),FoodDetails(searchKeyWords: "", fdicID: 0, brandOwner: "Mars Inc.", brandName: "M&M Mars", brandedFoodCategory: "Confectionary and Sweets", description: "Snickers Crunchers, Chocolate Candy Bar", servingSize: 80, servingSizeUnit: "g", carbs: "25", totalSugars: "12.5", totalStarches: "12.5", wholeFood: "no")]
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
                                Image(systemName: isFocused || search == .active ? "arrow.left" :  "magnifyingglass")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(Color(UIColor.label).opacity(0.6))
                                    .onTapGesture {
                                        isFocused = false
                                        search = .unfocused
                                        searchText = ""
                                    }
                                ZStack (alignment: .leading) {
                                    searchText.count > 0 ? nil : SearchCarouselView()
                                    TextField("", text: $searchText)
                                        .foregroundColor(Color(UIColor.label))
                                        .frame(width: 245, height: 35)
                                        .focused($isFocused)
                                        .onChange(of: isFocused, initial: false) {
                                            if isFocused && search != .active {
                                                search = .focused
                                            }
                                        }
                                        .onSubmit {
                                            search = .active
                                        }
                                }
                            }.padding(.leading)
                        }
                        Menu {
                            Picker("", selection: $selectedSort) {
                                ForEach(sortingOptions, id: \.self){ option in
                                    Button(action: {self.selectedSort = option}, label: {
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
                    }
                    .padding(.top, 10)
                    .onTapGesture {
                        isFocused = true
                    }
                    
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
                                                            Image(systemName: "plus")
                                                                .foregroundStyle(.iconTeal)
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
                        Text("Recent searches live here along with recommendations")
                    case .active:
                        LazyVGrid(columns: [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]) {
                            ForEach(searchFilters, id: \.self) { filter in
                                Button(action: {selectedFilter = filter}, label: {
                                    Text(filter.selected)
                                        .font(.system(size: 13, weight: selectedFilter.selected == filter.selected ? .bold : .semibold))
                                        .foregroundStyle( selectedFilter.selected == filter.selected ? Color(UIColor.label) : Color(UIColor.label).opacity(0.3))
                                })
                                .background(
                                    RoundedRectangle(cornerRadius: 7)
                                        .fill(.clear)
                                        .stroke(selectedFilter.selected == filter.selected ? Color(UIColor.label) : Color(UIColor.label).opacity(0.3), lineWidth: selectedFilter.selected == filter.selected ? 2 : 1)
                                        .frame(width: 105, height: 30))
                            }
                        }.padding(.horizontal, 25).padding(.vertical, 20)
                        List(searchResults, id: \.self) {food in
                            SearchResultCellView(result: food)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
                        }
                        .listStyle(.plain)
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
