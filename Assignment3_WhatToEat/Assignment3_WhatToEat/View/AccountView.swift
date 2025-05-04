//
//  AccountView.swift
//  Assignment3_WhatToEat
//
//  Created by Junhui Ye on 3/5/2025.
//

import SwiftUI

struct AccountView: View {
    @ObservedObject var loginModel: LoginViewModel
    @AppStorage("currentUser") var currentUser: Data?
    @Environment(\.dismiss) var dismiss
    
    var user: User? {
            guard let currentUser = currentUser,
                  let user = try? JSONDecoder().decode(User.self, from: currentUser) else {
                return nil
            }
            return user
        }
    
    var body: some View {
        VStack {
            if let user = user {
                Text("Name: \(user.name)")
                    .font(.title)
                Text("Email: \(user.email)")
                    .font(.body)
                Text("Password: \(user.password)")
                    .font(.body)
                Button("Logout") {
                    loginModel.reset()
                    dismiss() //dismiss the view once logged out
                }
            } else {
                Text("No user data available.")
            }
        }
        .padding()
        .navigationTitle("Account")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AccountView(loginModel: LoginViewModel())
}
