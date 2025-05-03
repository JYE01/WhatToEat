//
//  FirebaseTestViewModel.swift
//  Assignment3_WhatToEat
//
//  Created by Junhui Ye on 30/4/2025.
//

import Foundation
import FirebaseFirestore

class FirestoreManager: ObservableObject {
    private var db = Firestore.firestore()
    @Published var recipes: [Recipe] = []
    
    func fetchRecipes() {
        db.collection("Recipes").addSnapshotListener { snapshot, error in //collection name is Recipes in firebase firestore/
            if let error = error {
                print("Error getting recipes: \(error)")
                return
            }

            self.recipes = snapshot?.documents.compactMap { document in
                try? document.data(as: Recipe.self)
            } ?? []
        }
    }
    func fetchUser(byEmail email: String, completion: @escaping (User?) -> Void) {
        db.collection("Users") //collection name is Users in firebase firestore
            .whereField("email", isEqualTo: email)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching user: \(error.localizedDescription)")
                    completion(nil)
                    return
                }

                guard let document = snapshot?.documents.first else { //email is unique so there will be only one (.first)
                    completion(nil)
                    return
                }

                do {
                    let user = try document.data(as: User.self)
                    completion(user)
                } catch {
                    print("Error decoding user: \(error.localizedDescription)")
                    completion(nil)
                }
            }
    }
}
