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
    @Published var name: String = ""
    @Published var canLogin: Bool = false
    @Published var cannotLogin: String? = nil
    @Published var canRegister: Bool = false
    @Published var cannotRegister: String? = nil
    @Published var compeleRegister: String? = nil
    
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
                    self.cannotLogin = nil
                    
                    if let encodedUser = try? JSONEncoder().encode(user) {
                        UserDefaults.standard.set(encodedUser, forKey: "currentUser") //save in userDefaults first
                    }
                } else {
                    self.cannotLogin = "Incorrect password."
                    self.canLogin = false
                }
            }
        }
    }
    
    func register() {
        guard !email.isEmpty, !password.isEmpty, !name.isEmpty else { //check empty fields
            self.cannotRegister = "All fields are required."
            return
        }
        
        firestoreManager.fetchUser(byEmail: email) { userExists in
            DispatchQueue.main.async {
                if userExists != nil { //when user already exists with email
                    self.cannotRegister = "User already registered"
                    return
                }
                
                let newUser: [String: Any] = [ //create new user
                    "email": self.email,
                    "password": self.password,
                    "name": self.name
                ]
                
                self.firestoreManager.db.collection("Users").addDocument(data: newUser) { error in //add to firebase firestore
                    if error != nil {
                        self.cannotRegister = "Registeration failed"
                    } else {
                        self.cannotRegister = nil
                        self.canRegister = true
                        self.compeleRegister = "Registeration complete!"
                    }
                }
            }
        }
    }
    
    func reset() {
        email = ""
        password = ""
        cannotLogin = nil
        canLogin = false
        
        UserDefaults.standard.removeObject(forKey: "currentUser")
    }
}
