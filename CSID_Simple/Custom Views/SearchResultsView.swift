//
//  SearchResultsView.swift
//  CSID_Simple
//
//  Created by Vince Muller on 11/3/24.
//

import SwiftUI

struct SearchResultsView: View {
    
    @State var searchResults: [FoodDetails] = []
    @State var selectedSort: String
    
    var body: some View {
        ScrollView {
            LazyVGrid (columns: [GridItem(.flexible())], spacing: 5) {
                ForEach(searchResults, id: \.self) {food in
                    SearchResultCellView(result: food, isFavorite: true, selectedSort: selectedSort)
                }.padding(.bottom, 5)
            }.padding(.top)
        }
    }
}

#Preview {
    SearchResultsView(selectedSort: "Relevance")
}
