//
//  SectionTitleView.swift
//  CSID_Simple
//
//  Created by Vince Muller on 2/2/25.
//

import SwiftUI

struct SectionTitleView: View {
    
    var label: String
    
    var body: some View {
        Text(label)
            .font(.system(size: 25, weight: .semibold))
            .foregroundStyle(.white)
            .frame(width: 350, alignment: .leading)
            .padding(.vertical, 10)
    }
}

#Preview {
    SectionTitleView(label: "Saved Lists")
}
