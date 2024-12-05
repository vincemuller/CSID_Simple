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
            case .session:
                HomeScreen()
                    .environmentObject(sessionViewModel)
            }
        }
    }
    
    private func configureAmplify() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure()
            
            if let awsUserData = Amplify.Auth.getCurrentUser() {
                PersistenceManager.retrieveUserSession { [self] result in
                    switch result {
                    case .success(let persistedUserData):
                        if persistedUserData == awsUserData.userId {
                            user = awsUserData.userId
                            sessionViewModel.authState = .session
                        } else {
                            sessionViewModel.authState = .login
                            let _ = Amplify.Auth.signOut()
                            PersistenceManager.logOut()
                        }
                    case .failure(let failure):
                        sessionViewModel.authState = .login
                        let _ = Amplify.Auth.signOut()
                        PersistenceManager.logOut()
                        print(failure.localizedDescription)
                    }
                }
            } else {
                let _ = Amplify.Auth.signOut()
                PersistenceManager.logOut()
            }
            print("Successfully configured Amplify!")
        } catch {
            print("Failed to configure Amplify", error)
        }
    }
}
