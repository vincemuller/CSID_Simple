//
//  StandardTextView.swift
//  CSID_Simple
//
//  Created by Vince Muller on 2/2/25.
//

import SwiftUI

struct StandardTextView: View {
    var label: String
    var size: CGFloat
    var weight: Font.Weight = .regular
    var textColor: Color = .white
    
    var body: some View {
        Text(label)
            .font(.system(size: size, weight: weight))
            .foregroundStyle(textColor)
    }
}

#Preview {
    StandardTextView(label: "25g", size: 16)
}
