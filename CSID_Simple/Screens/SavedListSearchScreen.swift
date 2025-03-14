//
//  SavedListSearchScreen.swift
//  CSID_Simple
//
//  Created by Vince Muller on 1/8/25.
//

import SwiftUI



struct SavedListSearchScreen: View {
    @EnvironmentObject var user: User
//    @StateObject private var viewModel = ViewModel()
    @FocusState private var isFocused: Bool
    @State private var editListScreenPresenting: Bool = false
    @State private var selectedFood: FoodDetails = FoodDetails(searchKeyWords: "", fdicID: 0, brandedFoodCategory: "", description: "", servingSize: 0, servingSizeUnit: "", carbs: "", totalSugars: "", totalStarches: "", wholeFood: "")
    @State private var foodDetalsPresenting: Bool = false
    @State private var compareQueue: [FoodDetails] = []
    @State private var selectedSort: String = "Relevance"
    @State private var savedFoods: [FoodDetails] = []
    @State private var searchResults: [FoodDetails] = []
    @State private var searchText: String = ""
    @State private var search: Search = .isNotFocused
    
    private let sortingOptions = ["Relevance",
                                  "Carbs (Low to High)",
                                  "Carbs (High to Low)",
                                  "Sugars (Low to High)",
                                  "Sugars (High to Low)",
                                  "Starches (Low to High)",
                                  "Starches (High to Low)"]
    
    
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
                                        searchSavedFoods()
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
                        search == .isFocused ? searchSavedFoods() : nil
                    }
                }
                ScrollView {
                    LazyVGrid (columns: [GridItem(.flexible())], spacing: 5) {
                        ForEach(searchResults, id: \.self) {food in
                            SearchResultCellView(searchResultCellType: .savedLists, logServingSizeSheetIsPresenting: .constant(false), isPresenting: $foodDetalsPresenting, selectedFood: $selectedFood, compareQueue: $compareQueue, result: food, selectedSort: selectedSort)
                        }.padding(.bottom, 5)
                    }
                }
            }.padding(.top, 10)
        }
        .sheet(isPresented: $editListScreenPresenting, onDismiss: {
            editListScreenPresenting = false
        }) {
            EditListScreen(list: list)
        }
        .sheet(isPresented: $foodDetalsPresenting, onDismiss: {
            foodDetalsPresenting = false
        }) {
            FoodDetailsScreen(food: $selectedFood)
        }
        .onChange(of: user.userSavedFoods, {
            getSavedListFoods()
        })
        .onAppear {
            getSavedListFoods()
        }
    }
    
    private func getSavedListFoods() {
        //Build search terms "USDAFoodSearchTable.fdicID = 2700004"
        var searchTerms: [String] = []
        
        for i in user.userSavedFoods {
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
