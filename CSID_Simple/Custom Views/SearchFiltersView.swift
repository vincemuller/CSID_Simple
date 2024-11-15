//
//  SearchFiltersView.swift
//  CSID_Simple
//
//  Created by Vince Muller on 11/3/24.
//

import SwiftUI

struct SearchFiltersView: View {
    
    @Binding var selectedFilter: SearchFilter
    @State var searchText: String
    
    let searchFoods: () -> ()
    
    private let searchFilters: [SearchFilter] = SearchFilter.allCases

    
    var body: some View {
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
    }
}

#Preview {
    SearchFiltersView(selectedFilter: .constant(.allFoods), searchText: "") {
        print("search executed!")
    }
}
