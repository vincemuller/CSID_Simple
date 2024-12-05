//
//  SignUpResetPasswordScreen.swift
//  CSID_Simple
//
//  Created by Vince Muller on 11/20/24.
//

import SwiftUI

struct LogInResetPasswordScreen: View {
    @EnvironmentObject var sessionViewModel: SessionViewModel
    
    @State var email: String
    @State private var confirmationCode: String = ""
    @State private var password: String = ""
    @State private var passwordConfirmation: String = ""
    
    var body: some View {
        ZStack (alignment: .top) {
            BackgroundView()
            VStack (spacing: 0) {
                Image("csidAssistLogo")
                    .resizable()
                    .frame(width: 140, height: 140)
                Text("Reset Password\n")
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
                            Image(systemName: "person.crop.circle.fill.badge.checkmark")
                                .font(.system(size: 20))
                                .foregroundStyle(.white)
                            TextField("", text: $confirmationCode, prompt: Text("Confirmation Code").foregroundColor(.white.opacity(0.4)))
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
                            TextField("", text: $password, prompt: Text("New Password").foregroundColor(.white.opacity(0.4)))
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
                            TextField("", text: $passwordConfirmation, prompt: Text("Confirm New Password").foregroundColor(.white.opacity(0.4)))
                                .foregroundStyle(.white)
                                .font(.system(size: 18))
                                .offset(y: 3)
                        }.frame(width: 300)
                        Rectangle()
                            .fill(.white)
                            .frame(width: 300, height: 1)
                            .padding(.top, 3)
                        VStack (spacing: 10) {
                            Button(action: {                        guard password == passwordConfirmation else {
                                print("password and confirmation don't match")
                                return
                            }
                            sessionViewModel.changePassword(username: email, newPassword: password, code: confirmationCode)}, label: {
                                Text("Reset Password")
                                    .font(.system(size: 18))
                                    .frame(width: 200, height: 40)
                                    .foregroundStyle(.black)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(.white))
                            })
                            Button(action: {print("")}, label: {
                                Text("Resend confirmation code")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.white.opacity(0.6))
                            })
                        }.offset(y: 25)
                    }.offset(y: 30)
                }.frame(width: 360, height: 370).offset(y: 20)
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
    LogInResetPasswordScreen(email: "vmuller2529@gmail.com")
        .environmentObject(SessionViewModel())
}
