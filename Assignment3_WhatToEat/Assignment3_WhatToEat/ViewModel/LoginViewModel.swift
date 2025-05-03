//
//  LoginViewModel.swift
//  Assignment3_WhatToEat
//
//  Created by Junhui Ye on 3/5/2025.
//

import Foundation
import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var canLogin: Bool = false
    @Published var cannotLogin: String? = nil
    @Published var showHome = false
    
    @AppStorage("userData") var currentUser: Data?
    
    private var firestoreManager = FirestoreManager()
    
    func login() {
        firestoreManager.fetchUser(byEmail: email) { user in
            DispatchQueue.main.async {
                guard let user = user else {
                    self.cannotLogin = "User not found."
                    self.canLogin = false
                    return
                }

                if user.password == self.password {
                    self.canLogin = true
                    self.showHome = true
                    self.cannotLogin = nil
                    
                    if let encodedUser = try? JSONEncoder().encode(user) {
                        self.currentUser = encodedUser //save the current user
                    }
                } else {
                    self.cannotLogin = "Incorrect password."
                    self.canLogin = false
                }
            }
        }
    }
    
    func reset() {
        email = ""
        password = ""
        cannotLogin = nil
    }
}
