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
