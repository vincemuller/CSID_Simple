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
    @StateObject var user = User()
    @State var authState: AuthState = .authenticated
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    
    var body: some Scene {
        WindowGroup {
            HomeScreen()
                .environmentObject(user)
                .onAppear {
                    configureAmplify()
                    Task {
                        await user.getSavedLists()
                        await user.getSavedFoods()
                        await user.getUserMeals(selectedDay: Date().getNormalizedDate(adjustor: 0))
                        
        //                await User.shared.testMealLogging()
                    }
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
