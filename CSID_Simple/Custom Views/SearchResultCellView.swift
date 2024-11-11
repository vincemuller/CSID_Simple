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
    
//    @State var isPresenting: Bool = false
    
    @State private var deepDive: Bool = false
    @Binding var isPresenting: Bool
    @Binding var selectedFood: FoodDetails
    @Binding var compareQueue: [FoodDetails]
    @State var result: FoodDetails
    @State var isFavorite: Bool
    @State var selectedSort: String = "Relevance"
    @State var selectedCellAction: String = ""
    
    var cellActions: [String] = ["Expand Details", "Select to Compare"]
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
        
        ZStack (alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 8)
                .fill(compareQueue.contains(where: {$0.fdicID == result.fdicID}) ? .green.opacity(0.3) : .textField)
                .stroke(deepDive ? Color(UIColor.label) : .clear)
            switch deepDive {
            case false:
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
                            .lineLimit(3)
                            .minimumScaleFactor(0.75)
                            .frame(width: 245, height: 45, alignment: .topLeading)
                            .offset(y: 5)
                        Spacer()
                    }.frame(width: 245, height: 80).offset(x: 3, y: 2)
                }
            case true:
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
        }
        .onTapGesture {
            selectedFood = result
            isPresenting = true
        }
        .frame(width: 360, height: deepDive ? 140 : 80)
//        .overlay(alignment: .topTrailing) {
//            Image(systemName: !isFavorite ? "bookmark" : "bookmark.fill")
//                .font(.system(size: 20))
//                .foregroundStyle(.iconTeal)
//                .padding(.horizontal, 5)
//                .padding(.top, 7)
//        }
        .overlay(alignment: .bottomTrailing, content: {
            Button(action: {
                deepDive.toggle()
            }, label: {
                Image(systemName: deepDive ? "chevron.up" : "chevron.down")
                    .font(.system(size: 16))
                    .foregroundStyle(.iconTeal)
                    .padding(7)
            })
        })
        .overlay(alignment: .topTrailing) {
            Menu {
                Button(action: {
                    if !compareQueue.contains(where: {$0.fdicID == result.fdicID}) {
                        compareQueue.append(result)
                    } else {
                        compareQueue.removeAll(where: {$0.fdicID == result.fdicID})
                    }
                }, label: {
                    if !compareQueue.contains(where: {$0.fdicID == result.fdicID}) {
                        Text("Select Food to Compare")
                    } else {
                        Text("Deselect Food to Compare")
                    }
                })
            } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 16))
                    .foregroundStyle(.iconTeal)
                    .padding(7)
            }

        }

    }
}

#Preview {
    SearchResultCellView(isPresenting: .constant(false), selectedFood: .constant(FoodDetails(searchKeyWords: "", fdicID: 0, brandedFoodCategory: "", description: "", servingSize: 0, servingSizeUnit: "", carbs: "", totalSugars: "", totalStarches: "", wholeFood: "")), compareQueue: .constant([]), result: FoodDetails(searchKeyWords: "", fdicID: 0, brandOwner: "Mars Inc.", brandName: "M&M Mars", brandedFoodCategory: "Confectionary and Sweets", description: "Snickers Crunchers", servingSize: 80, servingSizeUnit: "g", carbs: "25", totalSugars: "12.5", totalStarches: "12.5", wholeFood: "no"), isFavorite: false, selectedSort: "Relevance")
}
