//
//  SavedListsView.swift
//  CSID_Simple
//
//  Created by Vince Muller on 11/11/24.
//

import SwiftUI

struct SavedListsView: View {
    
    var savedListMockData = ["Safe Foods","Unsafe Foods","Favorite Snacks","Favorite Treats"]
    
    @Binding var createListScreenPresenting: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(.textField)
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
                        }.onTapGesture {
                            createListScreenPresenting = true
                        }
                    }
                    
                    HStack {
                        Image(systemName: "bookmark")
                            .foregroundStyle(.white)
                        Text(list)
                            .foregroundStyle(.white)
                            .font(.system(size: 16))
                    }
                }.listRowBackground(Color.clear)
            }
            .scrollIndicators(.hidden)
            .padding(.trailing)
        }.frame(width: 350, height: 175)
    }
}

#Preview {
    SavedListsView(createListScreenPresenting: .constant(false))
}
