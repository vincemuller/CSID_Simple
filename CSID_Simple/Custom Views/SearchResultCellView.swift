//
//  CA_SearchResultCell2.swift
//  CSIDAssistPlus
//
//  Created by Vince Muller on 10/28/24.
//

import SwiftUI

enum nutritionalLabel: CaseIterable {
    case relevance, sugars, starches
    var id: Self { self }
    var label: String {
        switch self {
        case .relevance:
            return "Net Carbs"
        case .sugars:
            return "Sugars"
        case .starches:
            return "Starches"
        }
    }
}

struct SearchResultCellView: View {
    
    @State private var deepDive: Bool = false
    @State var result: FoodDetails
    @State var isFavorite: Bool
    @State var selectedSort: String = "Relevance"
    
    private var nutritionalData: [String] {
        switch selectedSort {
        case "Relevance":
            return [result.carbs,"Net Carbs"]
        case "Sugars (Low to High)":
            return [result.totalSugars, "Sugars"]
        case "Sugars (High to Low)":
            return [result.totalSugars, "Sugars"]
        case "Starches (Low to High)":
            return [result.totalStarches, "Starches"]
        case "Starches (High to Low)":
            return [result.totalStarches, "Starches"]
        case "Carbs (Low to High)":
            return [result.carbs,"Net Carbs"]
        case "Carbs (High to Low)":
            return [result.carbs,"Net Carbs"]
        default:
            return [result.carbs,"Net Carbs"]
        }
    }
    
    var body: some View {
        
        let brand = result.brandName?.brandFormater(brandOwner: result.brandOwner ?? "")
        switch deepDive {
        case false:
            ZStack (alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.textField)
                HStack (alignment: .top, spacing: 0) {
                    VStack (spacing: 3) {
                        Text("\(nutritionalData[0])g")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color(UIColor.label))
                        Text(nutritionalData[1])
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundStyle(Color(UIColor.label).opacity(0.6))
                    }.frame(width: 70, height: 80, alignment: .top).offset(y: 20)
                    Rectangle()
                        .fill(.iconTeal)
                        .frame(width: 4, height: 50)
                        .offset(y: 18)
                        .padding(.trailing, 5)
                    VStack (alignment: .leading, spacing: 0) {
                        Text(brand ?? "")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundStyle(.iconTeal)
                            .lineLimit(1)
                            .offset(y: 1)
                        Text(result.description)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color(UIColor.label))
                            .lineLimit(deepDive ? 5 : 3)
                            .minimumScaleFactor(0.75)
                            .frame(width: 245, height: deepDive ? nil : 45, alignment: .topLeading)
                            .offset(y: 7)
                        Spacer()
                    }.frame(width: 245, height: deepDive ? 100 : 80).offset(x: 3, y: 2)
                }
            }
            .overlay(alignment: .topTrailing) {
                !isFavorite  ? nil :
                Image(systemName: "bookmark.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(.iconTeal)
                    .padding(.horizontal, 5)
                    .padding(.top, 7)
            }
            .frame(width: 360, height: !deepDive ? 80 : 120)
            .onTapGesture {
                print(result.fdicID)
            }
            .onLongPressGesture {
                withAnimation(.bouncy) {
                    deepDive.toggle()
                }
            }
        case true:
            ZStack (alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.textField)
                    .stroke(Color(UIColor.label))
                HStack (alignment: .top, spacing: 0) {
                    VStack (spacing: 0) {
                        Text("\(result.carbs)g")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color(UIColor.label))
                        Text("Total Carbs")
                            .font(.system(size: 8, weight: .semibold))
                            .foregroundStyle(Color(UIColor.label).opacity(0.6))
                            .padding(.bottom, 7)
                        Text("\(result.totalSugars)g")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color(UIColor.label))
                        Text("Total Sugars")
                            .font(.system(size: 8, weight: .semibold))
                            .foregroundStyle(Color(UIColor.label).opacity(0.6))
                            .padding(.bottom, 7)
                        Text("\(result.totalStarches)g")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color(UIColor.label))
                        Text("Total Starches")
                            .font(.system(size: 8, weight: .semibold))
                            .foregroundStyle(Color(UIColor.label).opacity(0.6))
                    }.frame(width: 70, height: 80, alignment: .top).offset(y: 20)
                    Rectangle()
                        .fill(.iconTeal)
                        .frame(width: 4, height: 110)
                        .offset(y: 18)
                        .padding(.trailing, 5)
                    VStack (alignment: .leading, spacing: 0) {
                        VStack (alignment: .leading) {
                            Text(brand ?? "")
                                .font(.system(size: 10, weight: .semibold))
                                .foregroundStyle(.iconTeal)
                                .lineLimit(1)
                                .offset(y: 1)
                            Text(result.description)
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(Color(UIColor.label))
                                .lineLimit(deepDive ? 5 : 3)
                                .minimumScaleFactor(0.75)
                                .frame(width: 245, alignment: .topLeading)
                                .offset(y: 5)
                        }
                        .frame(width: 245, height: 100, alignment: .topLeading)
                        .padding(.bottom, 5)
                        
                        Text("Serving Size: \(result.servingSize.description)\(result.servingSizeUnit)")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(.iconTeal)
                            .lineLimit(1)
                        Spacer()
                    }.offset(x: 3, y: 2)
                }
            }
            .overlay(alignment: .topTrailing) {
                !isFavorite  ? nil :
                Image(systemName: "bookmark.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(.iconTeal)
                    .padding(.horizontal, 5)
                    .padding(.top, 7)
            }
            .frame(width: 360, height: 140)
            .onTapGesture {
                print(result.fdicID)
            }
            .onLongPressGesture {
                withAnimation(.bouncy) {
                    deepDive.toggle()
                }
            }
        }
    }
}

#Preview {
    SearchResultCellView(result: FoodDetails(searchKeyWords: "", fdicID: 0, brandOwner: "Mars Inc.", brandName: "M&M Mars", brandedFoodCategory: "Confectionary and Sweets", description: "Snickers Crunchers, Chocolate Bar, asdfasdfasdf, asdfasdfasdf, asdfasdfasdf, asdfasdfasdf, Chocolate Bar, asdfasdfasdf, asdfasdfasdf, asdfasdfasdf, asdfasdfasdf", servingSize: 80, servingSizeUnit: "g", carbs: "25", totalSugars: "12.5", totalStarches: "12.5", wholeFood: "no"), isFavorite: true, selectedSort: "Relevance")
}
