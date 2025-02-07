//
//  MealLoggingSearchResultView.swift
//  CSID_Simple
//
//  Created by Vince Muller on 2/1/25.
//

import SwiftUI

struct MealLoggingSearchResultsView: View {
    
    @Binding var isPresenting: Bool
    @Binding var logServingSizeSheetIsPresenting: Bool
    @Binding var selectedFood: FoodDetails
    @Binding var searchResults: [FoodDetails]
    @State var selectedSort: String
    
    var savedFoods: [Int] = []
    
    var body: some View {
        ScrollView {
            LazyVGrid (columns: [GridItem(.flexible())], spacing: 5) {
                ForEach(searchResults, id: \.self) {food in
                    SearchResultCell(result: food)
                }.padding(.bottom, 5)
            }
        }
    }
    
    private func SearchResultCell(result: FoodDetails) -> some View {
        @State var deepDive: Bool = false
        @State var isFavorite: Bool = savedFoods.contains(result.fdicID)
        
        var nutritionalData: [String] {
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
        
        let brand = result.brandName?.brandFormater(brandOwner: result.brandOwner ?? "")
        let deepDiveNutData: [[String]] = [["Total Carbs", result.carbs], ["Total Sugars", result.totalSugars], ["Total Starches", result.totalStarches]]
        
        return ZStack (alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 8)
                .fill(.textField)
                .stroke(deepDive ? .white : .clear)
            switch deepDive {
            case false:
                HStack (alignment: .top, spacing: 0) {
                    VStack (spacing: 3) {
                        Text("\(nutritionalData[0])g")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                        Text(nutritionalData[1])
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.6))
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
                            .foregroundStyle(.white)
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
                        ForEach(deepDiveNutData, id: \.self) { nutrition in
                            Text("\(nutrition[1])g")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.white)
                            Text(nutrition[0])
                                .font(.system(size: 8, weight: .semibold))
                                .foregroundStyle(.white.opacity(0.6))
                                .padding(.bottom, 7)
                        }
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
                                .foregroundStyle(.white)
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
        .overlay(alignment: .bottomTrailing, content: {
            Button(action: {
                withAnimation(.linear.speed(2)) {
                    deepDive.toggle()
                }
            }, label: {
                Image(systemName: deepDive ? "chevron.up" : "chevron.down")
                    .font(.system(size: 16))
                    .foregroundStyle(.iconTeal)
                    .padding(7)
            })
        })
        .overlay(alignment: .topTrailing) {
            Button {
                logServingSizeSheetIsPresenting = true
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.iconTeal)
                    .padding(7)
            }
        }
        
    }
}

#Preview {
    MealLoggingSearchResultsView(isPresenting: .constant(false), logServingSizeSheetIsPresenting: .constant(false), selectedFood: .constant(FoodDetails(searchKeyWords: "", fdicID: 0, brandedFoodCategory: "", description: "", servingSize: 0, servingSizeUnit: "", carbs: "", totalSugars: "", totalStarches: "", wholeFood: "")), searchResults: .constant([]), selectedSort: "")
}
