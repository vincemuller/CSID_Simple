//
//  CA_SearchResultCell2.swift
//  CSIDAssistPlus
//
//  Created by Vince Muller on 10/28/24.
//

import SwiftUI

struct newUSDAFoodDetails: Codable, Hashable {
    var searchKeyWords:         String
    var fdicID:                 Int
    var brandOwner:             String?
    var brandName:              String?
    var brandedFoodCategory:    String
    var description:            String
    var servingSize:            Float
    var servingSizeUnit:        String
    var carbs:                  String
    var totalSugars:            String
    var totalStarches:          String
    var wholeFood:              String
}


struct SearchResultCellView: View {
    
    @State var result: newUSDAFoodDetails
    
    var body: some View {
        
        let brand = result.brandName?.brandFormater(brandOwner: result.brandOwner ?? "")
        ZStack (alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 8)
                .fill(.textField)
            HStack (spacing: 0) {
                ZStack {
                    VStack {
                        Text("\(result.carbs)g")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(Color(UIColor.label))
                        Text("Net Carbs")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundStyle(Color(UIColor.label).opacity(0.6))
                    }.frame(width: 70, height: 75)
                }
                Rectangle()
                    .fill(.iconTeal)
                    .frame(width: 4, height: 50)
                    .padding(.trailing, 5)
                VStack (alignment: .leading, spacing: 0) {
                    Text(brand ?? "")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(.iconTeal)
                        .padding(.horizontal, 6)
                        .padding(.bottom, 3)
                    HStack {
                        VStack (alignment: .leading, spacing: 0) {
                            Text(result.description)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(Color(UIColor.label))
                                .lineLimit(3)
                                .minimumScaleFactor(0.8)
                                .frame(width: 245, alignment: .topLeading)
                                .offset(y: -3)
                        }
                    }.padding(.horizontal, 5).offset(y: 4)
                }.offset(y: -7)
            }
        }
        .frame(width: 360, height: 75)
        .overlay(alignment: .topTrailing) {
            Image(systemName: "bookmark.fill")
                .font(.system(size: 20))
                .foregroundStyle(.iconTeal)
                .padding(.horizontal, 5)
                .padding(.top, 10)
        }
        .onTapGesture {
            print(result.fdicID)
        }
    }
}

#Preview {
    SearchResultCellView(result: newUSDAFoodDetails(searchKeyWords: "", fdicID: 0, brandOwner: "Mars Inc.", brandName: "M&M Mars", brandedFoodCategory: "Confectionary and Sweets", description: "Snickers Crunchers, Chocolate Candy Bar", servingSize: 80, servingSizeUnit: "g", carbs: "25", totalSugars: "12.5", totalStarches: "12.5", wholeFood: "no"))
}
