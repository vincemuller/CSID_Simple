//
//  SavedListSearchScreen.swift
//  CSID_Simple
//
//  Created by Vince Muller on 1/8/25.
//

import SwiftUI



struct SavedListSearchScreen: View {
    
    @StateObject private var viewModel = ViewModel()
    @FocusState private var isFocused: Bool
    @State private var editListScreenPresenting: Bool = false
    @State private var compareQueue: [FoodDetails] = []
    @State private var selectedSort: String = "Relevance"
    @State private var savedFoods: [FoodDetails] = []
    @State private var searchResults: [FoodDetails] = []
    @State private var searchText: String = ""
    @State private var search: Search = .isNotFocused
    
    
    
    var list: SavedLists
    
    var body: some View {
        ZStack {
            BackgroundView()
                .navigationTitle(list.name ?? "")
                .navigationBarItems(trailing: Text("Edit").onTapGesture(perform: {
                    editListScreenPresenting = true
                }))
            VStack (spacing: 15) {
                HStack (spacing: 10) {
                    SearchBarView(searchText: $searchText, isFocused: $isFocused, searchState: $search, resetSearch: resetSearch, searchFoods: searchSavedFoods)
                    SortResultsView(selectedSort: $selectedSort)
                        .onChange(of: selectedSort) {
                            searchSavedFoods()
                        }
                }
                SearchResultsView(isPresenting: $viewModel.foodDetalsPresenting, selectedFood: $viewModel.selectedFood, compareQueue: $compareQueue, searchResults: $searchResults, selectedSort: selectedSort, savedFoods: [])
            }.padding(.top, 10)
        }
        .sheet(isPresented: $editListScreenPresenting, onDismiss: {
            editListScreenPresenting = false
        }) {
            EditListScreen(list: list)
        }
        .sheet(isPresented: $viewModel.foodDetalsPresenting, onDismiss: {
            viewModel.foodDetalsPresenting = false
        }) {
            FoodDetailsScreen(food: $viewModel.selectedFood)
        }
        .onAppear {
            getSavedListFoods()
        }
    }
    
    private func getSavedListFoods() {
        //Build search terms "USDAFoodSearchTable.fdicID = 2700004"
        var searchTerms: [String] = []
        
        for i in User.shared.userSavedFoods {
            if i.savedListsID == list.id {
                searchTerms.append("USDAFoodSearchTable.fdicID = \(i.fdicID?.description ?? "")")
            }
        }
        
        let sT = searchTerms.joined(separator: " OR ")
        
        DispatchQueue(label: "search.serial.queue").async {
            let queryResult = DatabaseQueries.databaseSavedFoodsSearch(searchTerms: sT, databasePointer: databasePointer)
            print(queryResult)
            
            DispatchQueue.main.async {
                self.savedFoods = queryResult
                self.searchResults = queryResult
            }
        }
    }
    
    private func searchSavedFoods() {
        var searchTerms: [String] = searchText.lowercased().components(separatedBy: " ")
        
        searchTerms.removeAll(where: {$0.isEmpty})
        
        searchResults = savedFoods
        print(searchTerms)
        
        for i in searchTerms {
            searchResults = searchResults.filter {$0.searchKeyWords.lowercased().contains(i)}
        }
        
        switch selectedSort {
        case "Relevance":
            searchResults.sort(by: {$0.searchKeyWords.count < $1.searchKeyWords.count})
        case "Sugars (Low to High)":
            searchResults.removeAll(where: {$0.totalSugars == "N/A"})
            searchResults.sort(by: {Float($0.totalSugars) ?? 0 < Float($1.totalSugars) ?? 0})
        case "Sugars (High to Low)":
            searchResults.removeAll(where: {$0.totalSugars == "N/A"})
            searchResults.sort(by: {Float($0.totalSugars) ?? 0 > Float($1.totalSugars) ?? 0})
        case "Starches (Low to High)":
            searchResults.removeAll(where: {$0.totalStarches == "N/A"})
            searchResults.sort(by: {Float($0.totalStarches) ?? 0 < Float($1.totalStarches) ?? 0})
        case "Starches (High to Low)":
            searchResults.removeAll(where: {$0.totalStarches == "N/A"})
            searchResults.sort(by: {Float($0.totalStarches) ?? 0 > Float($1.totalStarches) ?? 0})
        case "Carbs (Low to High)":
            searchResults.removeAll(where: {$0.carbs == "N/A"})
            searchResults.sort(by: {Float($0.carbs) ?? 0 < Float($1.carbs) ?? 0})
        case "Carbs (High to Low)":
            searchResults.removeAll(where: {$0.carbs == "N/A"})
            searchResults.sort(by: {Float($0.carbs) ?? 0 > Float($1.carbs) ?? 0})
        default:
            searchResults.sort(by: {$0.searchKeyWords.count < $1.searchKeyWords.count})
        }
        
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
    
    private func resetSearch() {
        isFocused = false
        searchText = ""
        searchResults = savedFoods
        search = .isNotFocused
        selectedSort = "Relevance"
    }
    
}

#Preview {
    SavedListSearchScreen(list: SavedLists())
}
