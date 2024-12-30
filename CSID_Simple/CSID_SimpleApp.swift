//
//  CSID_SimpleApp.swift
//  CSID_Simple
//
//  Created by Vince Muller on 10/29/24.
//

import SwiftUI
import Amplify
import AWSPluginsCore
import AWSAPIPlugin

enum LogInActionType {
    case logIn, logOut
}

enum AuthState {
    case signUp, logIn, authenticated
}

@main
struct CSID_SimpleApp: App {
    
    @State var authState: AuthState = .authenticated
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    var body: some Scene {
        WindowGroup {
            switch authState {
            case .signUp:
                SignUpScreen()
            case .logIn:
                LogInScreen()
            case .authenticated:
                HomeScreen()
                    .onAppear {
                        configureAmplify()
                    }
            }
        }
    }
    
    private func configureAmplify() {
        do {
            try Amplify.add(plugin: AWSAPIPlugin())
            try Amplify.configure()
            print("Amplify configured!")
        } catch {
            print("An error occurred setting up Amplify: \(error)")
        }
    }
    
    private func getTolerationRating() async {
        do {
            let result = try await Amplify.API.query(
                request: .get(TolerationRating.self,
                byId: "d5d61ae8-f62a-49f2-8c95-11fee6b73827")
            )
            switch result {
            case .success(let model):
                guard let model = model else {
                    print("Could not find model")
                    return
                }
                print("Successfully retrieved model: \(model)")
            case .failure(let error):
                print("Got failed result with \(error)")
            }
        } catch let error as APIError {
            print("Failed to query TolerationRating - \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
}
