//
//  SavedListsScreen.swift
//  CSID_Simple
//
//  Created by Vince Muller on 12/5/24.
//

import SwiftUI
import Amplify
import AWSPluginsCore


struct CreateListScreen: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var user: User
    
    @FocusState private var isFocused: Bool
    
    @State private var listName: String = ""
    @State private var description: String = ""
    
    
    var body: some View {
        ZStack (alignment: .topLeading) {
            BackgroundView()
            VStack (alignment: .leading, spacing: 10) {
                Text("Create a list")
                    .font(.system(size: 30, weight: .semibold))
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                VStack (alignment: .leading) {
                    Text("List Name")
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
                        .padding(.leading, 3)
                    VStack (alignment: .leading, spacing: 0) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.textField)
                                .stroke(listName.isEmpty ? .red : .clear)
                            TextField("", text: $listName, prompt: Text("Ex: Safe foods list").foregroundColor(.white.opacity(0.4)))
                                .foregroundStyle(.white)
                                .font(.system(size: 18))
                                .focused($isFocused)
                                .padding()
                        }.frame(height: 60)
                        Text(listName.isEmpty ? "Required field" : "")
                            .font(.callout)
                            .foregroundStyle(.red)
                            .padding(.leading, 5)
                            .padding(.top, 5)
                    }.padding(.bottom, 10)
                    Text("Description")
                        .font(.system(size: 20))
                        .foregroundStyle(.white)
                        .padding(.leading, 3)
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.textField)
                        TextField("", text: $description, prompt: Text("Add list description").foregroundColor(.white.opacity(0.4)), axis: .vertical)
                            .foregroundStyle(.white)
                            .font(.system(size: 18))
                            .frame(height: 120, alignment: .topLeading)
                            .padding()
                    }.frame(height: 120, alignment: .topLeading)
                }
                .offset(y: 30)
                Spacer()
                VStack {
                    Button(action: {
                        Task {
                            await createSavedList()
                        }
                           }, label: {
                        Text("Save List")
                            .font(.system(size: 18))
                            .frame(width: 300, height: 40)
                            .foregroundStyle(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.iconTeal))
                    })
                    .disabled(listName.isEmpty ? true : false)
                    .opacity(listName.isEmpty ? 0.3 : 1.0)
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
    
    private func createSavedList() async {
        let model = SavedLists(name: listName,
                               description: description,
                               userID: "vmuller2529")
        do {
            let result = try await Amplify.API.mutate(request: .create(model))
            switch result {
            case .success(let model):
                print("Successfully created TolerationRating: \(model)")
                Task {
                    await user.getSavedLists()
                    self.presentationMode.wrappedValue.dismiss()
                }
            case .failure(let graphQLError):
                print("Failed to create graphql \(graphQLError)")
            }
        } catch let error as APIError {
            print("Failed to create TolerationRating - \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
}

#Preview {
    CreateListScreen()
}

