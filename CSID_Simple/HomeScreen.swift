//
//  ContentView.swift
//  CSID_Simple
//
//  Created by Vince Muller on 10/29/24.
//

import SwiftUI

struct HomeScreen: View {
    
    @State private var searchText: String = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        NavigationStack {
            ZStack (alignment: .top) {
                LinearGradient(colors: [.backgroundColor1,.backgroundColor2,.backgroundColor1], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                    .navigationTitle("CSIDAssist")
                VStack {
                    ZStack (alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.textField)
                            .frame(width: 360, height: 40)
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(Color(UIColor.label).opacity(0.6))
                            ZStack (alignment: .leading) {
                                searchText.count > 0 ? nil : SearchCarouselView()
                                TextField("", text: $searchText)
                                    .foregroundColor(.black)
                                    .frame(width: 275, height: 35, alignment: .leading)
                                    .focused($isFocused)
                            }
                        }.padding(.leading)
                    }
                    .padding(.top, 10)
                    .onTapGesture {
                        isFocused = true
                    }
                    Spacer()
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
