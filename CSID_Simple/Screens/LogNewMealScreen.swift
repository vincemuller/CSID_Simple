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


struct LogNewMealScreen: View {
    @FocusState var isFocused: Bool
    @State private var mealName: String = ""
    @State private var mealFoods: [FoodDetails] = []
    @State private var additionalNotes: String = ""
    @State private var selectedRating: SelectedToleration = .couldTolerate

    @State var mealType: MealType

    var body: some View {
        ZStack {
            BackgroundView()
            ScrollView {
                VStack (alignment: .leading, spacing: 15) {
                    Text(mealType.label)
                        .font(.system(size: 30, weight: .semibold))
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                    Text("Meal Name")
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
                        .padding(.leading, 3)
                        .padding(.bottom, 3)
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.textField)
                        TextField("", text: $mealName, prompt: Text("Ex: Mixed Berry Smoothie").foregroundColor(.white.opacity(0.4)))
                            .foregroundStyle(.white)
                            .font(.system(size: 18))
                            .focused($isFocused)
                            .padding()
                    }
                    .frame(height: 40)
                    .padding(.bottom, 10)
                    Text("Foods")
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
                        .padding(.leading, 3)
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(.textField, lineWidth: 2)
                        .frame(height: 350)
                        .padding(.bottom, 10)
                    Text("How well did you tolerate this meal?")
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
                        .padding(.leading, 3)
                    HStack (spacing: 10) {
                        Text(selectedRating.definition)
                            .font(.system(size: 10))
                            .foregroundStyle(selectedRating.color)
                            .frame(width: 200)
                        Menu {
                            Picker("", selection: $selectedRating) {
                                ForEach(SelectedToleration.allCases){ option in
                                    Button(action: {
                                        self.selectedRating = option
                                    }, label: {
                                        Text(option.label)
                                    })
                                }
                            }
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(selectedRating.color)
                                HStack (spacing: 5) {
                                    Text(selectedRating.label)
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundStyle(.white)
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundStyle(.white)
                                        .offset(y: 2)
                                }.offset(x: 5)
                            }.frame(width: 140, height: 40, alignment: .center)
                        }
                    }
                    .padding(.bottom, 10)
                    Text("Additional Notes:")
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
                        .padding(.leading, 3)
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.textField)
                        TextField("", text: $additionalNotes, prompt: Text("Add additional notes and details...").foregroundColor(.white.opacity(0.4)), axis: .vertical)
                            .foregroundStyle(.white)
                            .font(.system(size: 18))
                            .frame(height: 75, alignment: .topLeading)
                            .padding()
                    }
                    .frame(height: 75, alignment: .topLeading)
                    VStack {
                        Button(action: {print("")}, label: {
                            Text("Log \(mealType.label)")
                                .font(.system(size: 18))
                                .frame(width: 300, height: 40)
                                .foregroundStyle(.white)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.iconTeal))
                        })
                    }
                    .frame(width: 370)
                    .padding(.top, 50)
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    LogNewMealScreen(mealType: MealType.afternoonSnack)
}
