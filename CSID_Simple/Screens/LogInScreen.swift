//
//  LoginScreen.swift
//  CSID_Simple
//
//  Created by Vince Muller on 11/19/24.
//

import SwiftUI

struct LogInScreen: View {
    @EnvironmentObject var sessionViewModel: SessionViewModel
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var inProgress: Bool = false
    
    var body: some View {
        ZStack (alignment: .top) {
            BackgroundView()
            VStack (spacing: 0) {
                Image("csidAssistLogo")
                    .resizable()
                    .frame(width: 140, height: 140)
                Text("CSIDAssist")
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .offset(y: -20)
                ZStack (alignment: .top) {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.textField)
                    VStack {
                        HStack {
                            Image(systemName: "person.fill")
                                .font(.system(size: 20))
                                .foregroundStyle(.white)
                            TextField("", text: $email, prompt: Text("Email").foregroundColor(.white.opacity(0.4)))
                                .foregroundStyle(.white)
                                .font(.system(size: 18))
                                .offset(y: 3)
                        }.frame(width: 300)
                        Rectangle()
                            .fill(.white)
                            .frame(width: 300, height: 1)
                            .padding(.top, 3)
                            .padding(.bottom, 25)
                        HStack {
                            Image(systemName: "lock.fill")
                                .font(.system(size: 20))
                                .foregroundStyle(.white)
                            TextField("", text: $password, prompt: Text("Password").foregroundColor(.white.opacity(0.4)))
                                .foregroundStyle(.white)
                                .font(.system(size: 18))
                                .offset(y: 3)
                        }.frame(width: 300)
                        Rectangle()
                            .fill(.white)
                            .frame(width: 300, height: 1)
                            .padding(.top, 3)
                        VStack (spacing: 10) {
                            Button(action: {sessionViewModel.signIn(username: email, password: password);inProgress = true}, label: {
                                Text(inProgress ? "• • •" : "Sign In")
                                    .font(.system(size: 18))
                                    .frame(width: 200, height: 40)
                                    .foregroundStyle(.black)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(.white))
                            })
                            Button(action: {sessionViewModel.resetPassword(email: email)}, label: {
                                Text("Forgot Password?")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.white.opacity(0.6))
                            })
                        }.offset(y: 25)
                    }.offset(y: 50)
                }.frame(width: 360, height: 260).offset(y: 50)
                Spacer()
                Button(action: {sessionViewModel.showSignUp()}, label: {
                    Text("Don't have an account? Click Here")
                        .font(.system(size: 14))
                        .foregroundStyle(.iconTeal)
                })
            }
        }
        .alert(sessionViewModel.errTitle, isPresented: $sessionViewModel.isShowing) {
            Button("Ok") {
                sessionViewModel.isShowing = false
            }
        } message: {
            Text(sessionViewModel.errMessage)
        }
        .onDisappear(perform: {
            inProgress = false
        })
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    LogInScreen()
        .environmentObject(SessionViewModel())
}
