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
            HomeScreen()
                .onAppear {
                    configureAmplify()
                }
//            switch authState {
//            case .signUp:
//                SignUpScreen()
//            case .logIn:
//                LogInScreen()
//            case .authenticated:
//                HomeScreen()
//                    .onAppear {
//                        configureAmplify()
//                    }
//            }
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
    
}
