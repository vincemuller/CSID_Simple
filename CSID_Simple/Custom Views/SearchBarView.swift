//
//  SearchBarView.swift
//  CSID_Simple
//
//  Created by Vince Muller on 11/12/24.
//

import SwiftUI


struct SearchBarView: View {
    
    @Binding var searchText: String
    @FocusState.Binding var isFocused: Bool
    @Binding var searchState: Search
    
    var resetSearch: () -> Void
    var searchFoods: () -> Void
    
    var body: some View {
        ZStack (alignment: .leading) {
            RoundedRectangle(cornerRadius: 10)
                .fill(.textField)
                .frame(width: 300, height: 40)
            HStack {
                Image(systemName:  searchState != .isNotFocused ? "arrow.left" :  "magnifyingglass")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.6))
                    .onTapGesture {
                        if searchState != .isNotFocused {
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
                                searchState = .isFocused
                            }
                        })
                        .onSubmit {
                            searchFoods()
                        }
                }
            }.padding(.leading)
        }
    }
}

#Preview {
    SearchBarView(searchText: .constant(""), isFocused: FocusState<Bool>().projectedValue, searchState: .constant(.isNotFocused)) {
        print("reset search function here")
    } searchFoods: {
        print("search foods function here")
    }


}
