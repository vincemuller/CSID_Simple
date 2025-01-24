//
//  RatingsPieChartView.swift
//  CSID_Simple
//
//  Created by Vince Muller on 12/31/24.
//

import SwiftUI
    
struct RatingsPieChartView: View {
    @Binding var tolerationChunks: TolerationChunks
    @State var tolerationRatingCount: Int
    @State var majorityLabel: String = ""
    
    var width: CGFloat?

    var body: some View {
        ZStack {
            switch (tolerationRatingCount == 0) {
            case true:
                Circle()
                    .stroke(.white.opacity(0.15), lineWidth: 30)
                    .frame(width: width)
            case false:
                Circle()
                    .trim(from: 0.0, to: Double(tolerationChunks.canNotTolerate.count) / Double(tolerationRatingCount))
                    .stroke(.red, lineWidth: 30)
                    .frame(width: width)
                Circle()
                    .trim(from: Double(tolerationChunks.canNotTolerate.count) / Double(tolerationRatingCount), to: (Double(tolerationChunks.canNotTolerate.count) / Double(tolerationRatingCount) + Double(tolerationChunks.tolerateWithStipulations.count) / Double(tolerationRatingCount)))
                    .stroke(.iconYellow, lineWidth: 30)
                    .frame(width: width)
                Circle()
                    .trim(from: (Double(tolerationChunks.canNotTolerate.count) / Double(tolerationRatingCount) + Double(tolerationChunks.tolerateWithStipulations.count) / Double(tolerationRatingCount)), to: 1.0)
                    .stroke(.iconTeal, lineWidth: 30)
                    .frame(width: width)
            }
            Text(tolerationRatingCount != 0 ? majorityLabel : "No Ratings or Reviews")
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 80, height: 50)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    RatingsPieChartView(tolerationChunks: .constant(TolerationChunks(canNotTolerate: [], tolerateWithStipulations: [], canTolerate: [])), tolerationRatingCount: 0)
}
