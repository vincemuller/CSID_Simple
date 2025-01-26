//
//  MealLoggingScreen.swift
//  CSID_Simple
//
//  Created by Vince Muller on 1/26/25.
//

import SwiftUI

struct MealLoggingScreen: View {
    
    
    var mealType: MealType
    
    var body: some View {
        ZStack (alignment: .topLeading) {
            BackgroundView()
            VStack (alignment: .leading, spacing: 10) {
                Text(mealType.label)
                    .font(.system(size: 30, weight: .semibold))
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
            }.padding()
        }
    }
}

#Preview {
    MealLoggingScreen(mealType: .breakfast)
}
