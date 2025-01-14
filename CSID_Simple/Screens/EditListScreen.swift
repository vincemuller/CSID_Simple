//
//  EditListsScreen.swift
//  CSID_Simple
//
//  Created by Vince Muller on 12/5/24.
//

import SwiftUI
import Amplify
import AWSPluginsCore


struct EditListScreen: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @FocusState private var isFocused: Bool
    
    @State private var listName: String = ""
    @State private var description: String = ""
    
    @State var list: SavedLists
    
    var body: some View {
        ZStack (alignment: .topLeading) {
            BackgroundView()
            VStack (alignment: .leading, spacing: 10) {
                Text("Edit list")
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
                        list.name = listName
                        list.description = description
                        Task {
                            await updateSavedLists(updatedModel: list)
                        }
                           }, label: {
                        Text("Update List")
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
            listName = list.name ?? ""
            description = list.description ?? ""
        }
    }
    
    private func updateSavedLists(updatedModel: SavedLists) async {
        do {
            let result = try await Amplify.API.mutate(request: .update(updatedModel))
            switch result {
            case .success(let model):
                print("Successfully updated SavedLists: \(model)")
                self.presentationMode.wrappedValue.dismiss()
            case .failure(let error):
                print("Got failed result with \(error.errorDescription)")
            }
        } catch let error as APIError {
            print("Failed to update SavedLists - \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
}

#Preview {
    EditListScreen(list: SavedLists())
}

