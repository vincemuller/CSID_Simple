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

struct HomeScreen: View {
    
    @FocusState private var isFocused: Bool
    
    @State private var sections: HomeScreenSections = .activity
    @State private var searchText: String = ""
    @State private var selectedSort: String = "Relevance"
    
    private var sortingOptions = ["Relevance", "Carbs (Low to High)", "Carbs (High to Low)", "Sugars (Low to High)", "Sugars (High to Low)", "Starches (Low to High)", "Starches (High to Low)"]
    
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
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(Color(UIColor.label).opacity(0.6))
                                ZStack (alignment: .leading) {
                                    searchText.count > 0 ? nil : SearchCarouselView()
                                    TextField("", text: $searchText)
                                        .foregroundColor(.black)
                                        .frame(width: 245, height: 35)
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
                    List {
                        ForEach(HomeScreenSections.allCases) {section in
                            Section {
                                switch sections {
                                case .activity:
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color(UIColor.label).opacity(0.5))
                                        .frame(width: 350, height: 100)
                                case .meals:
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color(UIColor.label).opacity(0.5))
                                        .frame(width: 350, height: 100)
                                case .lists:
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color(UIColor.label).opacity(0.5))
                                        .frame(width: 350, height: 100)
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
                }
            }
        }
        .overlay(alignment: .topLeading, content: {
            Image("csidAssistLogo")
                .resizable()
                .frame(width: 80, height: 80)
                .safeAreaPadding(.top)
                .padding(.leading)
        })
        .ignoresSafeArea()
    }
}

#Preview {
    HomeScreen()
}
