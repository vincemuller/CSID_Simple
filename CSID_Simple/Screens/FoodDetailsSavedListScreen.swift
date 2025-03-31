//
//  FoodDetailsSavedListScreen.swift
//  CSID_Simple
//
//  Created by Vince Muller on 1/4/25.
//

import SwiftUI
import Amplify
import AWSPluginsCore


struct FoodDetailsSavedListScreen: View {
    @EnvironmentObject var user: User

    @State private var toSave: [SavedFoods] = []
    @State private var toDelete: [SavedFoods] = []
    
    @State var fdicID: Int
    
    
    var body: some View {
        ZStack {
            Color.textField
            VStack (alignment: .center) {
                Text("Save to a list")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .frame(width: 350, alignment: .leading)
                    .padding(10)
                List(user.userSavedLists, id: \.id) {list in
                    if user.userSavedLists.firstIndex(of: list) == 0 {
                        HStack {
                            Image(systemName: "plus")
                                .foregroundStyle(.iconTeal)
                                .fontWeight(.semibold)
                            Text("Create New List")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.iconTeal)
                        }
                        .onTapGesture {
                            print("create function here")
                        }
                        .listRowBackground(Color.clear)
                    }
                    CheckboxToggleStyle(toSave: $toSave, toDelete: $toDelete, list: list, fdicID: fdicID)
                    .listRowBackground(Color.clear)
                }
                .listStyle(.plain)
                .frame(height: 180)
                Button(action: {
                    Task {
                        await createSavedFoods()
                        await deleteSavedFoods()
                        await user.getSavedFoods()
                    }
                       }, label: {
                    Text("Save")
                        .font(.system(size: 18))
                        .frame(width: 350, height: 40)
                        .foregroundStyle(.white)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.iconTeal))
                       })
                Spacer()
            }
        }
        .ignoresSafeArea()
    }
    
    private func createSavedFoods() async {
        toSave.removeAll { saveItem in
            user.userSavedFoods.contains { userItem in
                saveItem.fdicID == userItem.fdicID && saveItem.savedListsID == userItem.savedListsID
            }
        }
        for i in toSave {
            let model = SavedFoods(
                savedListsID: i.savedListsID,
                userID: user.userID,
                fdicID: fdicID)
            do {
                let result = try await Amplify.API.mutate(request: .create(model))
                switch result {
                case .success(let model):
                    print("Successfully created SavedFoods: \(model)")
                case .failure(let graphQLError):
                    print("Failed to create graphql \(graphQLError)")
                }
            } catch let error as APIError {
                print("Failed to create SavedFoods - \(error)")
            } catch {
                print("Unexpected error: \(error)")
            }
        }
    }
    
    private func deleteSavedFoods() async {
        
        guard !user.userSavedFoods.isEmpty else {
            toDelete.removeAll()
            return
        }
        
//        toDelete.removeAll { deleteItem in
//            user.userSavedFoods.contains { userItem in
//                !(deleteItem.fdicID == userItem.fdicID && deleteItem.savedListsID == userItem.savedListsID)}
//            }
        
        toDelete = user.userSavedFoods.filter { userItem in
            toDelete.contains { deleteItem in
                userItem.fdicID == deleteItem.fdicID && userItem.savedListsID == deleteItem.savedListsID
            }
        }
        
        print("to delete: \(toDelete.count)")
        
        for i in toDelete {
            let model = SavedFoods(
                id: i.id,
                savedListsID: i.savedListsID,
                userID: user.userID,
                fdicID: fdicID)
            do {
                let result = try await Amplify.API.mutate(request: .delete(model))
                switch result {
                case .success(let model):
                    print("Successfully deleted the following SavedFoods: \(model)")
                case .failure(let graphQLError):
                    print("Failed to create graphql \(graphQLError)")
                }
            } catch let error as APIError {
                print("Failed to delete SavedFoods - \(error)")
            } catch {
                print("Unexpected error: \(error)")
            }
        }

    }
    
}

#Preview {
    FoodDetailsSavedListScreen(fdicID: 1004)
        .environmentObject(User())
}

struct CheckboxToggleStyle: View {
    @EnvironmentObject var user: User
    
    @Binding var toSave: [SavedFoods]
    @Binding var toDelete: [SavedFoods]
    
    @State var list: SavedLists
    var fdicID: Int
    @State private var isOn: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: "bookmark")
                .foregroundStyle(.white)
            Text(list.name ?? "")
                .foregroundStyle(.white)
                .font(.system(size: 16))
            Spacer()
            RoundedRectangle(cornerRadius: 5.0)
                .stroke(lineWidth: 2)
                .frame(width: 25, height: 25)
                .cornerRadius(5.0)
                .overlay {
                    Image(systemName: isOn ? "checkmark" : "")
                }
                .onTapGesture {
                    isOn.toggle()
                    if isOn {
                        toDelete.removeAll(where: { $0.fdicID == fdicID && $0.savedListsID == list.id})
                        toSave.append(SavedFoods(id: UUID().uuidString, savedListsID: list.id, fdicID: fdicID))
                    } else {
                        toSave.removeAll(where: { $0.fdicID == fdicID && $0.savedListsID == list.id })
                        toDelete.append(SavedFoods(id: UUID().uuidString, savedListsID: list.id, fdicID: fdicID))
                    }
                }
        }
        .onAppear {
            if user.userSavedFoods.contains(where: {$0.fdicID == fdicID && $0.savedListsID == list.id}) && !toDelete.contains(where: {$0.fdicID == fdicID}) {
                isOn = true
            }
        }
    }
}
