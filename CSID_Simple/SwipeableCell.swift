import SwiftUI

struct SwipeItem<Content: View, Right: View>: View {
    var content: () -> Content
    var right: () -> Right
    var itemHeight: CGFloat
    
    @State var hoffset: CGFloat = 0
    @State var anchor: CGFloat = 0
    
    let screenWidth = UIScreen.main.bounds.width
    var anchorWidth: CGFloat { screenWidth / 3 }
    var swipeThreshold: CGFloat { screenWidth / 15 }
    
    @State var rightPast = false
    @State var leftPast = false
    
    init(@ViewBuilder content: @escaping () -> Content,
         @ViewBuilder right: @escaping () -> Right,
         itemHeight: CGFloat) {
        self.content = content
        self.right = right
        self.itemHeight = itemHeight
    }
    
    var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                withAnimation {
                    if value.translation.width > hoffset && hoffset == 0 {
                        return
                    }
                    hoffset = anchor + value.translation.width
                    
                    if abs(hoffset) > anchorWidth {
                        if leftPast {
                            hoffset = anchorWidth
                        } else if rightPast {
                            hoffset = -anchorWidth
                        }
                    }
                    
                    if anchor > 0 {
                        leftPast = hoffset > anchorWidth - swipeThreshold
                    } else {
                        leftPast = hoffset > swipeThreshold
                    }
                    
                    if anchor < 0 {
                        rightPast = hoffset < -anchorWidth + swipeThreshold
                    } else {
                        rightPast = hoffset < -swipeThreshold
                    }
                }
            }
            .onEnded { value in
                withAnimation {
                    if rightPast {
                        anchor = -anchorWidth
                    } else if leftPast {
                        anchor = 0
                    } else {
                        anchor = 0
                    }
                    
                    hoffset = anchor
                }
            }
    }
    
    var body: some View {
        GeometryReader { geo in
            HStack(spacing: 0) {
                
                content()
                    .frame(width: geo.size.width)
                    .zIndex(0)
                        
                
                right()
                    .frame(width: anchorWidth)
                    .zIndex(1)
                    .clipped()
            }
        }
        .offset(x: hoffset)
        .frame(maxHeight: itemHeight)
        .contentShape(Rectangle())
        .gesture(drag)
        .clipped()
    }
}

#Preview(body: {
    VStack {
        SwipeItem(content: {
            SearchResultCellView(isPresenting: .constant(false), selectedFood: .constant(FoodDetails(searchKeyWords: "", fdicID: 0, brandedFoodCategory: "", description: "", servingSize: 0, servingSizeUnit: "", carbs: "", totalSugars: "", totalStarches: "", wholeFood: "")), compareQueue: .constant([]), result: FoodDetails(searchKeyWords: "", fdicID: 0, brandOwner: "Mars Inc.", brandName: "M&M Mars", brandedFoodCategory: "Confectionary and Sweets", description: "Snickers Crunchers", servingSize: 80, servingSizeUnit: "g", carbs: "25", totalSugars: "12.5", totalStarches: "12.5", wholeFood: "no"), isFavorite: true, selectedSort: "Relevance")
        },
                  right: {
            ZStack {
                Rectangle()
                    .fill(Color.green)
                
                Text("Compare")
            }
        }, itemHeight: 80)
        SwipeItem(content: {
            SearchResultCellView(isPresenting: .constant(false), selectedFood: .constant(FoodDetails(searchKeyWords: "", fdicID: 0, brandedFoodCategory: "", description: "", servingSize: 0, servingSizeUnit: "", carbs: "", totalSugars: "", totalStarches: "", wholeFood: "")), compareQueue: .constant([]), result: FoodDetails(searchKeyWords: "", fdicID: 0, brandOwner: "Mars Inc.", brandName: "M&M Mars", brandedFoodCategory: "Confectionary and Sweets", description: "Snickers Crunchers", servingSize: 80, servingSizeUnit: "g", carbs: "25", totalSugars: "12.5", totalStarches: "12.5", wholeFood: "no"), isFavorite: true, selectedSort: "Relevance")
        },
                  right: {
            ZStack {
                Rectangle()
                    .fill(Color.green)
                
                Text("Compare")
            }
        }, itemHeight: 80)
    }
})


