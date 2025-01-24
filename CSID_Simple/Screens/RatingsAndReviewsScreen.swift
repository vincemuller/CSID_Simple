//
//  RatingsAndReviewsScreen.swift
//  CSID_Simple
//
//  Created by Vince Muller on 12/31/24.
//

import SwiftUI
import Amplify

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



struct RatingsAndReviewsScreen: View {

    @State private var selectedSort: RatingsSorter = .mostRecent
    
    var ratings: [TolerationRating] = []
    private var sortedRatings: [TolerationRating] {
        switch selectedSort {
        case .mostRecent:
            return ratings.sorted(by: {$0.createdAt ?? Temporal.DateTime.now() > $1.createdAt ?? Temporal.DateTime.now()})
        case .notTolerated:
            return ratings.filter({$0.rating == "0"})
        case .toleratedWithStipulations:
            return ratings.filter({$0.rating == "1"})
        case .tolerated:
            return ratings.filter({$0.rating == "2"})
        }
    }
    
    var body: some View {
        ZStack (alignment: .topLeading) {
            BackgroundView()
            VStack (spacing: 5) {
                HStack {
                    switch sortedRatings.count == 1 {
                    case true:
                        Text("\(sortedRatings.count) Rating and Review")
                    case false:
                        Text("\(sortedRatings.count) Ratings and Reviews")
                    }

                    Spacer()
                    Menu {
                        Picker("", selection: $selectedSort) {
                            ForEach(RatingsSorter.allCases) { option in
                                Button(action: {
                                    self.selectedSort = option
                                }, label: {
                                    Text(option.label)
                                })
                            }
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.textField)
                                .frame(width: 40, height: 40)
                            Image(systemName: "arrow.up.and.down.text.horizontal")
                                .foregroundColor(.white)
                        }
                    }
                }.padding()
                ScrollView {
                    LazyVGrid (columns: [GridItem(.flexible())], spacing: 5) {
                        ForEach(sortedRatings, id: \.id) {rating in
                            TolerationRatingView(rating: rating)
                                .padding(.bottom, 20)
                        }
                    }
                }.padding(.horizontal)
            }
        }
    }
}

#Preview {
    RatingsAndReviewsScreen()
}
