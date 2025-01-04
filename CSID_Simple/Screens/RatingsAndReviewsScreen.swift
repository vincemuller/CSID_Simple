//
//  RatingsAndReviewsScreen.swift
//  CSID_Simple
//
//  Created by Vince Muller on 12/31/24.
//

import SwiftUI

struct RatingsAndReviewsScreen: View {
    var ratings: [TolerationRating] = []
    var body: some View {
        ZStack (alignment: .topLeading) {
            BackgroundView()
            ScrollView {
                LazyVGrid (columns: [GridItem(.flexible())], spacing: 5) {
                    ForEach(ratings, id: \.id) {rating in
                        TolerationRatingView(rating: rating)
                            .padding(.bottom, 20)
                    }
                }
            }.padding()
        }
    }
}

#Preview {
    RatingsAndReviewsScreen()
}
