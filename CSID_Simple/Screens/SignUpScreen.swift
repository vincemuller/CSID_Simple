//
//  SignUpScreen.swift
//  CSID_Simple
//
//  Created by Vince Muller on 11/20/24.
//

import SwiftUI

struct SignUpScreen: View {
    @EnvironmentObject var sessionViewModel: SessionViewModel
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    var body: some View {
        ZStack (alignment: .top) {
            BackgroundView()
            VStack (spacing: 0) {
                Image("csidAssistLogo")
                    .resizable()
                    .frame(width: 140, height: 140)
                Text("Welcome!\nLets get a few details")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
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
                            Image(systemName: "lock")
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
                            .padding(.bottom, 25)
                        HStack {
                            Image(systemName: "lock.fill")
                                .font(.system(size: 20))
                                .foregroundStyle(.white)
                            TextField("", text: $confirmPassword, prompt: Text("Confirm Password").foregroundColor(.white.opacity(0.4)))
                                .foregroundStyle(.white)
                                .font(.system(size: 18))
                                .offset(y: 3)
                        }.frame(width: 300)
                        Rectangle()
                            .fill(.white)
                            .frame(width: 300, height: 1)
                            .padding(.top, 3)
                        VStack (spacing: 10) {
                            Button(action: {sessionViewModel.signUp(username: email, email: email, password: password)}, label: {
                                Text("Create Account")
                                    .font(.system(size: 18))
                                    .frame(width: 200, height: 40)
                                    .foregroundStyle(.white)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(.iconTeal))
                            })
                            Button(action: {sessionViewModel.showLogin()}, label: {
                                Text("Already have an account?")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.white.opacity(0.6))
                            })
                        }.offset(y: 25)
                    }.offset(y: 50)
                }.frame(width: 360, height: 320).offset(y: 50)
            }
        }
        .alert(sessionViewModel.errTitle, isPresented: $sessionViewModel.isShowing) {
            Button("Ok") {
                sessionViewModel.isShowing = false
            }
        } message: {
            Text(sessionViewModel.errMessage)
        }
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    SignUpScreen()
        .environmentObject(SessionViewModel())
}
