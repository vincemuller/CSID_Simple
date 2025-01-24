//
//  CreateRatingAndReviewScreen.swift
//  CSID_Simple
//
//  Created by Vince Muller on 12/31/24.
//

import SwiftUI
import Amplify
import AWSPluginsCore

enum SelectedToleration: Identifiable, CaseIterable {
    case couldTolerate, tolerateWithStipulations, couldNotTolerate
    var id: Self { self }
    var label: String {
        switch self {
        case .couldTolerate:
            return "Could Tolerate"
        case .tolerateWithStipulations:
            return "Tolerated With Stipulations"
        case .couldNotTolerate:
            return "Could Not Tolerate"
        }
    }
    
    var value: String {
        switch self {
        case .couldTolerate:
            return "2"
        case .tolerateWithStipulations:
            return "1"
        case .couldNotTolerate:
            return "0"
        }
    }
    
    var definition: String {
        switch self {
        case .couldTolerate:
            return "Could tolerate this food without any issues or special considerations"
        case .tolerateWithStipulations:
            return "Could tolerate this food, but only under specific conditions. For example: Eating it in small quantities, Combining it with other foods or enzymes, or Avoiding it in certain forms (e.g. cooked vs. raw)"
        case .couldNotTolerate:
            return "Could NOT tolerate this food at all. Eating this food causes significant symptoms or discomfort"
        }
    }
    
    var color: Color {
        switch self {
        case .couldTolerate:
            return .iconTeal
        case .tolerateWithStipulations:
            return .iconYellow
        case .couldNotTolerate:
            return .iconRed
        }
    }
    
}
struct CreateRatingAndReviewScreen: View {
    
    @Environment(\.presentationMode) var presentationMode
    @FocusState private var isFocused: Bool
    
    @State private var selectedRating: SelectedToleration = .couldTolerate
    @State private var comment: String = ""
    
    var fdicID: Int
    var ratings = ["Could Tolerate", "Tolerated With Stipulations", "Could Not Tolerate"]
    
    var body: some View {
        ZStack (alignment: .topLeading) {
            BackgroundView()
            VStack (alignment: .leading, spacing: 10) {
                Text("Rate and Review")
                    .font(.system(size: 30, weight: .semibold))
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                VStack (alignment: .leading) {
                        Text("How well did you tolerate this food?:")
                            .font(.system(size: 20))
                            .foregroundStyle(.white)
                            .padding(.leading, 3)
                    HStack (spacing: 10) {
                        Text(selectedRating.definition)
                            .font(.system(size: 10))
                            .foregroundStyle(selectedRating.color)
                            .frame(width: 200)
                        Menu {
                            Picker("", selection: $selectedRating) {
                                ForEach(SelectedToleration.allCases){ option in
                                    Button(action: {
                                        self.selectedRating = option
                                    }, label: {
                                        Text(option.label)
                                    })
                                }
                            }
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(selectedRating.color)
                                HStack (spacing: 5) {
                                    Text(selectedRating.label)
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundStyle(.white)
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundStyle(.white)
                                        .offset(y: 2)
                                }.offset(x: 5)
                            }.frame(width: 140, height: 40, alignment: .center)
                        }
                    }.frame(width: 350, alignment: .center).padding(.bottom, 30)
                    Text("Review Comments:")
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
                        .padding(.leading, 3)
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.textField)
                        TextField("", text: $comment, prompt: Text("Share an explanation for your rating...").foregroundColor(.white.opacity(0.4)), axis: .vertical)
                            .foregroundStyle(.white)
                            .font(.system(size: 14))
                            .frame(height: 120, alignment: .topLeading)
                            .padding()
                    }.frame(height: 120, alignment: .topLeading)
                }
                .offset(y: 30)
                Spacer()
                VStack {
                    Button(action: {
                        Task {
                            await createTolerationRating()
                            self.presentationMode.wrappedValue.dismiss()
                        }}, label: {
                        Text("Submit Rating")
                            .font(.system(size: 18))
                            .frame(width: 300, height: 40)
                            .foregroundStyle(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.iconTeal))
                    })
                }.frame(width: 360)
            }
            .padding(.top, 30)
            .padding(.horizontal)
        }
        .onTapGesture {
            hideKeyBoard()
        }
        .onAppear {
            isFocused = true
        }
    }
    
    private func createTolerationRating() async {
        guard !safeTextScan() else {
            print("failed safe text scan")
            return
        }
        
        let model = TolerationRating(
            fdicID: fdicID,
            comment: comment,
            userID: "vmuller2529",
            rating: selectedRating.value)
        do {
            let result = try await Amplify.API.mutate(request: .create(model))
            switch result {
            case .success(let model):
                print("Successfully created TolerationRating: \(model)")
            case .failure(let graphQLError):
                print("Failed to create graphql \(graphQLError)")
            }
        } catch let error as APIError {
            print("Failed to create TolerationRating - \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    private func safeTextScan() -> Bool {
        let unsafeWords: [String] = ["fuck","shit","ass","dick","asshole","arse","bitch","butthole"]
        
        return unsafeWords.contains(where: comment.lowercased().contains)
    }
    
}

#Preview {
    CreateRatingAndReviewScreen(fdicID: 0)
}
