//
//  LoginView.swift
//  Assignment3_WhatToEat
//
//  Created by Aranth Tjandra on 3/5/2025.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""//app storage to temporarily store login information

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Text("Welcome Back")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.appPrimaryOrange)

            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .textContentType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color.appLightOrange.opacity(0.2))
                .cornerRadius(8)

            SecureField("Password", text: $password)
                .textContentType(.password)
                .padding()
                .background(Color.appLightOrange.opacity(0.2))
                .cornerRadius(8)

            Button("Login") {
                //Need to add logic for login, link to a function.
                print("Login tapped (Email: \(email))")
             
            }
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(Color.appPrimaryOrange)
            .clipShape(Capsule())
            .shadow(color: Color.appPrimaryOrange.opacity(0.5), radius: 5, x: 0, y: 3)

            Button("Create New Account") {
    
            }//Need to add logic for creating account, link to a function.
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
            LoginView()
                .preferredColorScheme(.light)
        }

        NavigationView { // Wrap in NavigationView for preview
            LoginView()
                .preferredColorScheme(.dark)
        }
    }
}
