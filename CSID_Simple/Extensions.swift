//
//  Extensions.swift
//  CSIDAssistPlus
//
//  Created by Vince Muller on 7/27/24.
//

import Foundation
import SwiftUI


extension String {
    func dataFormater() -> String {
        guard self != "N/A" else {
            let formattedValue = "N/A"
            return formattedValue
        }
        
        guard let floatValue = Float(self) else { return "N/A" }
        
        let formattedValue = String(format: "%.1f",floatValue)
        
        return formattedValue
    }
    
    func brandFormater(brandOwner: String) -> String {
        
        if brandOwner == "N/A" && self != "N/A" {
            return self.capitalized
        } else if brandOwner != "N/A" && self == "N/A" {
            return brandOwner.capitalized
        } else if brandOwner != "N/A" && self != "N/A" {
            return "\(self.capitalized) | \(brandOwner.capitalized)"
        } else {
            return ""
        }
        
    }
}

extension View {
    func hideKeyBoard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

func customServingCalculator(actualServingSize: Float, customServing: String, nutrientData: NutrientData) -> NutrientData {
    //    guard let customPortionText = customServing, customServing.count != 0 else {
    //        totalCarbsData.text     = "\(foods.carbs)g"
    //        netCarbsData.text       = "\(foods.netCarbs)g"
    //        totalStarchData.text    = "\(foods.totalStarches)g"
    //        totalSugarsData.text    = "\(foods.totalSugars)g"
    //        return
    //    }
    
    let adjustor = getAdjustor(servingSize: actualServingSize, customPortion: customServing)
    
    return customPortionAdjustment(nutrientData: nutrientData, adjustor: adjustor)
}
    
func getAdjustor(servingSize: Float, customPortion: String) -> Float {
    let cP: Float           = Float(customPortion) ?? 1
    let adjustor:   Float   = cP/servingSize
    
    return adjustor
}
    
func customPortionAdjustment(nutrientData: NutrientData, adjustor: Float) -> NutrientData {
    var adjustedCarbs: String       = "N/A"
    var adjustedNetCarbs: String    = "N/A"
    var adjustedStarches: String    = "N/A"
    var adjustedTotalSugars: String = "N/A"
    var adjustedFiber: String       = "N/A"
    
    if nutrientData.carbs != "N/A" {
        let aC:  Float  = (Float(nutrientData.carbs)!*adjustor)
        adjustedCarbs   = String(format: "%.1f", aC)
    }
    
    if nutrientData.fiber != "N/A" {
        let aF:  Float  = (Float(nutrientData.fiber)!*adjustor)
        adjustedFiber   = String(format: "%.1f", aF)
    }
    
    if nutrientData.netCarbs != "N/A" {
        let aNC:  Float    = (Float(nutrientData.netCarbs)!*adjustor)
        adjustedNetCarbs   = String(format: "%.1f", aNC)
    }
    
    if nutrientData.totalStarches != "N/A" {
        let aS:  Float     = (Float(nutrientData.totalStarches)!*adjustor)
        adjustedStarches   = String(format: "%.1f", aS)
    }
    
    if nutrientData.totalSugars != "N/A" {
        let aTS:  Float     = (Float(nutrientData.totalSugars)!*adjustor)
        adjustedTotalSugars = String(format: "%.1f", aTS)
    }
    
    let adjustedNutrientData = NutrientData(carbs: adjustedCarbs, fiber: adjustedFiber, netCarbs: adjustedNetCarbs, totalSugars: adjustedTotalSugars, totalStarches: adjustedStarches, totalSugarAlcohols: "", protein: "", totalFat: "", sodium: "", ingredients: nutrientData.ingredients)
    //    let adjustedNutrientData = NutrientData(carbs: adjustedCarbs, fiber: "", netCarbs: adjustedNetCarbs, totalSugars: adjustedTotalSugars, totalStarches: adjustedStarches, totalSugarAlcohols: "", protein: "", totalFat: "", sodium: "")
    
    print(adjustedNutrientData)
    
    return adjustedNutrientData
}
