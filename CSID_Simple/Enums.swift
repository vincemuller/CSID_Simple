//
//  Enums.swift
//  CSID_Simple
//
//  Created by Vince Muller on 2/1/25.
//

import Foundation
import SwiftUI


enum HomeScreenSections: Identifiable, CaseIterable {
    case mealData, meals, lists
    var id: Self { self }
    var label: String {
        switch self {
        case .mealData:
            return "Daily Totals"
        case .meals:
            return "Meals"
        case .lists:
            return "Lists"
        }
    }
}

enum Search: CaseIterable {
    case isNotFocused, isFocused, searchInProgress
}

enum SearchFilter: Identifiable, CaseIterable {
    case wholeFoods, allFoods, brandedFoods
    var id: Self { self }
    var selected: String {
        switch self {
        case .wholeFoods:
            return "Whole Foods"
        case .allFoods:
            return "All Foods"
        case .brandedFoods:
            return "Branded Foods"
        }
    }
}

enum nutritionalLabel: CaseIterable {
    case relevance, sugars, starches
    var id: Self { self }
    var label: String {
        switch self {
        case .relevance:
            return "Total Carbs"
        case .sugars:
            return "Sugars"
        case .starches:
            return "Starches"
        }
    }
}

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

enum MealLoggingScreenTab: CaseIterable, Identifiable {
    case search, savedMeals
    var id: Self { self }
    var label: String {
        switch self {
        case .search:
            return "Search"
        case .savedMeals:
            return "Saved Meals"
        }
    }
}

enum Ingredients: Identifiable, CaseIterable {
    case sucroseIngredients, completeIngredientList, tolerationRatings
    var id: Self { self }
    var label: String {
        switch self {
        case .sucroseIngredients:
            return "Sucrose"
        case .completeIngredientList:
            return "Complete"
        case .tolerationRatings:
            return "Ratings & Reviews"
        }
    }
}

enum Toleration: Identifiable, CaseIterable {
    case canTolerate, canTolerateWithStipulations, canNotTolerate, inconclusive
    var id: Self { self }
    var label: String {
        switch self {
        case .canTolerate:
            return "Majority Can Tolerate"
        case .canTolerateWithStipulations:
            return "Majority Can Tolerate with Stipulations"
        case .canNotTolerate:
            return "Majority Can Not Tolerate"
        case .inconclusive:
            return "No Majority, See All Ratings"
        }
    }
}

enum RatingsSorter: Identifiable, CaseIterable {
    case mostRecent, notTolerated, toleratedWithStipulations, tolerated
    var id: Self { self }
    var label: String {
        switch self {
        case .mostRecent:
            return "Most Recent"
        case .tolerated:
            return "Could Tolerate"
        case .toleratedWithStipulations:
            return "Tolerated with Stipulations"
        case .notTolerated:
            return "Could Not Tolerate"
        }
    }
}

enum SelectedToleration: Identifiable, CaseIterable {
    case couldTolerate, tolerateWithStipulations, couldNotTolerate
    var id: Self { self }
    var label: String {
        switch self {
        case .couldTolerate:
            return "Could Tolerate"
        case .tolerateWithStipulations:
            return "Tolerated With Stipulations"
        case .couldNotTolerate:
            return "Could Not Tolerate"
        }
    }
    
    var value: String {
        switch self {
        case .couldTolerate:
            return "2"
        case .tolerateWithStipulations:
            return "1"
        case .couldNotTolerate:
            return "0"
        }
    }
    
    var definition: String {
        switch self {
        case .couldTolerate:
            return "Could tolerate this food without any issues or special considerations"
        case .tolerateWithStipulations:
            return "Could tolerate this food, but only under specific conditions. For example: Eating it in small quantities, Combining it with other foods or enzymes, or Avoiding it in certain forms (e.g. cooked vs. raw)"
        case .couldNotTolerate:
            return "Could NOT tolerate this food at all. Eating this food causes significant symptoms or discomfort"
        }
    }
    
    var color: Color {
        switch self {
        case .couldTolerate:
            return .iconTeal
        case .tolerateWithStipulations:
            return .iconYellow
        case .couldNotTolerate:
            return .iconRed
        }
    }
    
}
