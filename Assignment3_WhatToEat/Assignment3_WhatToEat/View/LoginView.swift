//
//  LoginView.swift
//  Assignment3_WhatToEat
//
//  Created by Aranth Tjandra on 3/5/2025.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var loginModel: LoginViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var showRegister = false

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Text("Welcome Back")
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

            SecureField("Password", text: $loginModel.password)
                .textContentType(.password)
                .padding()
                .background(Color.appLightOrange.opacity(0.2))
                .cornerRadius(8)
            
            if let error = loginModel.cannotLogin { //this will display login errors
                Text(error)
                    .foregroundColor(.red)
                    .font(.subheadline)
                    .padding(.top, -10)
            }

            Button("Login") {
                loginModel.login() //function for login from loginModel
                if loginModel.canLogin {
                    dismiss() //dismiss the view once logged in
                }
            }
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(Color.appPrimaryOrange)
            .clipShape(Capsule())
            .shadow(color: Color.appPrimaryOrange.opacity(0.5), radius: 5, x: 0, y: 3)
            
            NavigationLink(destination: RegisterView(loginModel: loginModel), isActive: $showRegister) {
                EmptyView()
            }

            Button("Create New Account") {
                showRegister = true
            }
            .font(.headline)
            .foregroundColor(.appPrimaryOrange)
            .padding(.top, 10)

            Spacer()
            Spacer()
        }
        .padding(.horizontal, 30)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground.edgesIgnoringSafeArea(.all))
        .navigationTitle("Login / Sign Up")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Preview
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView { // Wrap in NavigationView for preview
            LoginView(loginModel: LoginViewModel())
                .preferredColorScheme(.light)
        }

        NavigationView { // Wrap in NavigationView for preview
            LoginView(loginModel: LoginViewModel())
                .preferredColorScheme(.dark)
        }
    }
}
