//
//  MealTypeIconView.swift
//  CSID_Simple
//
//  Created by Vince Muller on 11/3/24.
//

import SwiftUI

struct MealTypeIconView: View {
    
    private var meals: [String] = ["Breakfast","Lunch","Dinner","Snack"]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(.textField)
                .frame(width: 350, height: 100)
            LazyVGrid(columns: [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())], content: {
                ForEach(meals, id: \.self) { meal in
                    VStack (spacing: 5) {
                        Image(meal.lowercased())
                            .resizable()
                            .frame(width: 55, height: 55)
                            .mask {
                                Circle()
                                    .frame(width: 50, height: 50)
                            }
                        Text(meal)
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .onTapGesture {
                        print(meal)
                    }
                }
            }).frame(width: 300, alignment: .center)
        }
    }
}

#Preview {
    MealTypeIconView()
}
