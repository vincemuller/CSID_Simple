//
//  Extensions.swift
//  CSIDAssistPlus
//
//  Created by Vince Muller on 7/27/24.
//

import Foundation


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
        
        if brandOwner == "" && self != "" {
            return self.capitalized
        } else if brandOwner != "" && self == "" {
            return brandOwner.capitalized
        } else if brandOwner != "" && self != "" {
            return "\(brandOwner.capitalized) | \(self.capitalized)"
        } else {
            return ""
        }
        
    }
    
}
