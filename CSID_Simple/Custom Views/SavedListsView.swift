//
//  SavedListsView.swift
//  CSID_Simple
//
//  Created by Vince Muller on 11/11/24.
//

import SwiftUI

struct SavedListsView: View {
    
    private var savedListMockData = ["Safe Foods","Unsafe Foods","Favorite Snacks","Favorite Treats"]
    
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
    SavedListsView()
}
