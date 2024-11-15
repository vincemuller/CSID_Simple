//
//  SortResultsView.swift
//  CSID_Simple
//
//  Created by Vince Muller on 11/3/24.
//

import SwiftUI

struct SortResultsView: View {
    
    @Binding var selectedSort: String
    
    private let sortingOptions = ["Relevance",
                                  "Carbs (Low to High)",
                                  "Carbs (High to Low)",
                                  "Sugars (Low to High)",
                                  "Sugars (High to Low)",
                                  "Starches (Low to High)",
                                  "Starches (High to Low)"]
    
    var body: some View {
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
    }
}

#Preview {
    SortResultsView(selectedSort: .constant("Relevance"))
}
