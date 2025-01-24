//
//  MealLogScreen.swift
//  CSID_Simple
//
//  Created by Vince Muller on 1/18/25.
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
    var order: Int {
        switch self {
        case .breakfast:
            return 1
        case .morningSnack:
            return 2
        case .lunch:
            return 3
        case .afternoonSnack:
            return 4
        case .dinner:
            return 5
        case .eveningSnack:
            return 6
        }
    }
}

struct MealLogScreen: View {
    

    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                Text("Log ")
                    .font(.system(size: 30, weight: .semibold))
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                Spacer()
            }
        }
    }
}

#Preview {
    MealLogScreen()
}
