//
//  RegisterView.swift
//  Assignment3_WhatToEat
//
//  Created by Junhui Ye on 4/5/2025.
//

import SwiftUI

struct RegisterView: View {
    @ObservedObject var loginModel: LoginViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text("Create Account")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.appPrimaryOrange)
            
            TextField("Email", text: $loginModel.email)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color.appLightOrange.opacity(0.2))
                .cornerRadius(8)
            
            TextField("Name", text: $loginModel.name)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color.appLightOrange.opacity(0.2))
                .cornerRadius(8)
            
            SecureField("Password", text: $loginModel.password)
                .textContentType(.password)
                .padding()
                .background(Color.appLightOrange.opacity(0.2))
                .cornerRadius(8)
            
            if let error = loginModel.cannotRegister { //this will display register errors
                Text(error)
                    .foregroundColor(.red)
                    .font(.subheadline)
            }
            
            Button("Register") {
                loginModel.register()
            }
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(Color.appPrimaryOrange)
            .clipShape(Capsule())
            .shadow(color: Color.appPrimaryOrange.opacity(0.5), radius: 5, x: 0, y: 3)
            
            if let complete = loginModel.compeleRegister { //when account is created, show confirm message
                Text(complete)
                    .foregroundColor(.green)
                    .font(.subheadline)
            }
            
            Spacer()
            Spacer()
        }
        .padding(.horizontal, 30)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground.edgesIgnoringSafeArea(.all))
        .navigationTitle("Create Account")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: loginModel.canRegister) { newValue in
            if newValue {
                dismiss()
                loginModel.reset()
            }
        }
    }
}

#Preview {
    RegisterView(loginModel: LoginViewModel())
}
