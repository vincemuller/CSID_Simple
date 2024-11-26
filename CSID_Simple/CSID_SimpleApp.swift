//
//  CSID_SimpleApp.swift
//  CSID_Simple
//
//  Created by Vince Muller on 10/29/24.
//

import Amplify
import AmplifyPlugins
import SwiftUI

enum LogInActionType {
    case logIn, logOut
}

@main
struct CSID_SimpleApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @ObservedObject var sessionViewModel = SessionViewModel()
    
    init() {
        configureAmplify()
    }
    
    var body: some Scene {
        WindowGroup {
            switch sessionViewModel.authState {
            case .signUp:
                SignUpScreen()
                    .environmentObject(sessionViewModel)
            case .login:
                LogInScreen()
                    .environmentObject(sessionViewModel)
            case .confirmCode(let username):
                SignUpConfirmationScreen(email: username)
                    .environmentObject(sessionViewModel)
            case .resetPassword(let username):
                LogInResetPasswordScreen(email: username)
                    .environmentObject(sessionViewModel)
            case .session(let user):
                HomeScreen()
                    .environmentObject(sessionViewModel)
            }
        }
    }
    
    private func configureAmplify() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
            if let u = Amplify.Auth.getCurrentUser() {
                user = u.userId
                sessionViewModel.authState = .session(user: u.userId)
            }
//            if let currentUser = Amplify.Auth.getCurrentUser() {
//                print(currentUser.userId)
//                PersistenceManager.logOut()
//                PersistenceManager.logIn(userID: currentUser.userId)
//                PersistenceManager.retrieveUserSession { result in
//                    switch result {
//                    case .success(let success):
//                        print(success)
//                    case .failure(let failure):
//                        print("failure!")
//                    }
//                }
//            }
            print("Successfully configured Amplify!")
        } catch {
            print("Failed to configure Amplify", error)
        }
    }
}
