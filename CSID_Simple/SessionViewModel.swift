//
//  SessionManager.swift
//  Portfolio_LogInPage
//
//  Created by Vince Muller on 7/18/24.
//

import Amplify
import SwiftUI

enum AuthState {
    case signUp
    case login
    case confirmCode(email: String)
    case resetPassword(email: String)
    case session(user: String)
}

final class SessionViewModel: ObservableObject {
    @Published var authState: AuthState = .login
    @Published var isShowing: Bool = false
    @Published var errTitle: String = "Error"
    @Published var errMessage: String = "The following error has occurred:\n\n"
    
    func getCurrentUser() {
        if let u = Amplify.Auth.getCurrentUser() {
            authState = .session(user: u.userId)
            PersistenceManager.logIn(userID: u.userId)
            user = u.userId
            print(u.userId)
        } else {
            authState = .login
        }
    }
    
    func showSignUp() {
        authState = .signUp
    }
    
    func showLogin() {
        authState = .login
    }
    
    func showResetPassword(email: String, code: String) {
        authState = .resetPassword(email: email)
    }
    
    func showDashboard(authUser: AuthUser) {
        authState = .session(user: authUser.userId)
        user = authUser.userId
    }
    
    func signUp(username: String, email: String, password: String) {
        print(username)
        let attributes = [AuthUserAttribute(.email, value: email)]
        let options = AuthSignUpRequest.Options(userAttributes: attributes)
        
        _ = Amplify.Auth.signUp(username: username, password: password, options: options) {
            [weak self] result in
            
            switch result {
                
            case .success(let signUpResult):
                print("Sign Up Success", signUpResult)
                
                switch signUpResult.nextStep {
                case .done:
                    print("Finished Sign Up")
                    
                case .confirmUser(let details, _):
                    print(details ?? "no details")
                    
                    DispatchQueue.main.async {
                        self?.authState = .confirmCode(email: username)
                    }
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.isShowing = true
                    self?.errTitle = "Sign Up Error"
                    self?.errMessage = "\nI apologize but it appears the following error occurred during sign up:\n\n\(error.errorDescription.description)"
                }
            }
        }
    }
    
    func confirm(username: String, code: String) {
        _ = Amplify.Auth.confirmSignUp(for: username, confirmationCode: code) {
            [weak self] result in
            
            switch result {
            case .success(let confirmResult):
                print(confirmResult)
                if confirmResult.isSignupComplete {
                    DispatchQueue.main.async {
                        self?.isShowing = true
                        self?.errTitle = "Welcome \(username)!"
                        self?.errMessage = "\nYou have successfully created an account! Hopefully this proves that I can develope authentication via AWSAmplify and Cognito."
                        self?.showLogin()
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    DispatchQueue.main.async {
                        self?.isShowing = true
                        self?.errTitle = "Confirmation Error"
                        self?.errMessage = "\nI apologize but it appears the following error occurred during confirmation:\n\n\(error.errorDescription.description)"
                    }
                }
            }
        }
    }
    
    func signIn(username: String, password: String) {
        _ = Amplify.Auth.signIn(username: username, password: password) {
            [weak self] result in
            
            switch result {
            case .success(let confirmSignIn):
                if confirmSignIn.isSignedIn {
                    DispatchQueue.main.async {
                        self?.getCurrentUser()
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.isShowing = true
                    self?.errTitle = "Sign In Error"
                    self?.errMessage = "\nI apologize but it appears the following error occurred during sign in:\n\n\(error.errorDescription.description)"
                }
            }
        }
    }
    
    func signOut() {
        _ = Amplify.Auth.signOut {
            [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.getCurrentUser()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.isShowing = true
                    self?.errTitle = "Sign Out Error"
                    self?.errMessage = "\nI apologize but it appears the following error occurred during sign out:\n\n\(error.errorDescription.description)"
                }
            }
        }
    }
    
    func resetPassword(email: String) {
        _ = Amplify.Auth.resetPassword(for: email) {
            [weak self] result in switch result {
            case .success(let result):
                DispatchQueue.main.async {
                    self?.authState = .resetPassword(email: email)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.isShowing = true
                    self?.errTitle = "Error"
                    self?.errMessage = "\nI apologize but it appears the following error occurred:\n\n\(error.errorDescription.description)"
                }
            }
        }
    }
    
    func changePassword(username: String, newPassword: String, code: String) {
        _ = Amplify.Auth.confirmResetPassword(for: username, with: newPassword, confirmationCode: code) {
            [weak self] result in
            
            switch result {
            case .success(let confirmResult):
                print(confirmResult)
                DispatchQueue.main.async {
                    self?.showLogin()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.isShowing = true
                    self?.errTitle = "Change Password Error"
                    self?.errMessage = "\nI apologize but it appears the following error occurred:\n\n\(error.errorDescription.description)"
                }
            }
        }
    }
    
    func iconLogInAttempt() {
        isShowing = true
        errTitle = "Development In Progress"
        errMessage = "\nThis feature is still in development.  Check back later to see it in action!"
    }
}
