//
//  TolerationRatingView.swift
//  CSID_Simple
//
//  Created by Vince Muller on 12/28/24.
//

import SwiftUI

struct TolerationRatingView: View {
    
    @State var rating: TolerationRating?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 1.5)
            VStack (alignment: .leading, spacing: 15) {
                HStack {
                    switch rating!.rating {
                    case 0.0:
                        Circle()
                            .fill(.red)
                            .frame(width: 13)
                        Text("Can Not Tolerate")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.white)
                    case 1.5:
                        Circle()
                            .fill(.yellow)
                            .frame(width: 13)
                        Text("Can Tolerate With Stipulations")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.white)
                    case 3.0:
                        Circle()
                            .fill(.green)
                            .frame(width: 13)
                        Text("Can Tolerate")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.white)
                    default:
                        Text("")
                    }
                }
                Text(rating?.comment ?? "")
                    .font(.system(size: 12))
                    .foregroundStyle(.white)
                Text(rating?.timestamp ?? Date.now, format: .dateTime.month().day().year())
                    .font(.system(size: 10))
                    .foregroundStyle(.white.opacity(0.5))
            }
        }
    }
}

#Preview {
    TolerationRatingView(rating: TolerationRating(fdicID: 1001, rating: 1.5, comment: "Could tolerate this food item but had to use sucraid prior to consuming.", userID: "vmuller2529", timestamp: Date.now))
}
