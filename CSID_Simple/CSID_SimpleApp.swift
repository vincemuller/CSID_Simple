//
//  CSID_SimpleApp.swift
//  CSID_Simple
//
//  Created by Vince Muller on 10/29/24.
//

import SwiftUI

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
            }
        }
    }
}
