//
//  SavedListsView.swift
//  CSID_Simple
//
//  Created by Vince Muller on 11/11/24.
//

import SwiftUI

struct SavedListsView: View {
    
    @Binding var savedLists: [SavedLists]
    @Binding var createListScreenPresenting: Bool
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.textField)
                    .frame(width: 350)
                ScrollView {
                    VStack (alignment: .leading, spacing: 10) {
                        ForEach(savedLists, id: \.id) { list in
                            if savedLists.firstIndex(of: list) == 0 {
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
                                Divider()
                                    .padding(.leading, 25)
                            }
                            NavigationLink(destination: SavedListSearchScreen(list: list)) {
                                HStack {
                                    Image(systemName: "bookmark")
                                        .foregroundStyle(.white)
                                    Text(list.name ?? "")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 16))
                                }
                            }
                            Divider()
                                .padding(.leading, 25)
                        }
                    }
                    .padding()
                }
                .frame(width: 350, height: 175, alignment: .leading)
            }
        }
    }
}

#Preview {
    SavedListsView(savedLists: .constant([]), createListScreenPresenting: .constant(false))
}
