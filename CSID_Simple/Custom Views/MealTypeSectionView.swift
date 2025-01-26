//
//  MealTypeIconView.swift
//  CSID_Simple
//
//  Created by Vince Muller on 11/3/24.
//

import SwiftUI

enum MealType: Identifiable, CaseIterable {
    case breakfast, morningSnack, lunch, afternoonSnack, dinner, eveningSnack
    var id: Self { self }
    var label: String {
        switch self {
        case .breakfast:
            return "Breakfast"
        case .morningSnack:
            return "Morning Snack"
        case .lunch:
            return "Lunch"
        case .afternoonSnack:
            return "Afternoon Snack"
        case .dinner:
            return "Dinner"
        case .eveningSnack:
            return "Evening Snack"
        }
    }
}

struct MealTypeSectionView: View {
    
    @State var opacity = 1.0
    @State private var presentSnackType: Bool = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(.textField)
                .frame(width: 350, height: 100)
            LazyVGrid(columns: [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())], content: {
                ForEach(MealType.allCases, id: \.id) { meal in
                    if  !meal.label.contains("Snack") {
                        NavigationLink(destination: MealLoggingScreen(mealType: meal)) {
                            VStack (spacing: 5) {
                                Image(meal.label.lowercased())
                                    .resizable()
                                    .frame(width: 55, height: 55)
                                    .mask {
                                        Circle()
                                            .frame(width: 50, height: 50)
                                    }
                                Text(meal.label)
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundStyle(.white)
                            }
                        }
                    }
                }
                Menu {
                    NavigationLink(destination: MealLoggingScreen(mealType: .morningSnack)) {
                        Text("Morning Snack")
                    }
                    NavigationLink(destination: MealLoggingScreen(mealType: .afternoonSnack)) {
                        Text("Afternoon Snack")
                    }
                    NavigationLink(destination: MealLoggingScreen(mealType: .eveningSnack)) {
                        Text("Evening Snack")
                    }
                } label: {
                    VStack (spacing: 5) {
                        Image("snack")
                            .resizable()
                            .frame(width: 55, height: 55)
                            .mask {
                                Circle()
                                    .frame(width: 50, height: 50)
                            }
                        Text("Snack")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                }
            }).frame(width: 300, alignment: .center)
        }
    }
}


#Preview {
    NavigationStack {
        ZStack {
            BackgroundView()
            MealTypeSectionView()
        }
    }
}
