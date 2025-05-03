//
//  AccountView.swift
//  Assignment3_WhatToEat
//
//  Created by Junhui Ye on 3/5/2025.
//

import SwiftUI

struct AccountView: View {
    @AppStorage("userData") var currentUser: Data?
    
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
    AccountView()
}
