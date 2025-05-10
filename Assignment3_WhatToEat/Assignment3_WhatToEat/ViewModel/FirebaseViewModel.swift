//
//  FirebaseTestViewModel.swift
//  Assignment3_WhatToEat
//
//  Created by Junhui Ye on 30/4/2025.
//

import Foundation
import FirebaseFirestore

class FirestoreManager: ObservableObject {
    @Published var db = Firestore.firestore()
    @Published var recipes: [Recipe] = []
    
    func fetchRecipes(completion: @escaping ([Recipe]) -> Void) {
            let db = Firestore.firestore()
            db.collection("Recipes").getDocuments { snapshot, error in
                if let documents = snapshot?.documents {
                    let recipes = documents.compactMap { doc in
                        try? doc.data(as: Recipe.self)
                    }
                    completion(recipes)
                } else {
                    completion([])
                }
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
    
    func addFavourite(forUserID userID: String, recipeID: String, completion: @escaping (Bool) -> Void) {
        db.collection("Users").document(userID).updateData([
            "favourites": FieldValue.arrayUnion([recipeID])
        ]) { error in
            completion(error == nil)
        }
    }
    
    func removeFavourite(forUserID userID: String, recipeID: String, completion: @escaping (Bool) -> Void) {
        db.collection("Users").document(userID).updateData([
            "favourites": FieldValue.arrayRemove([recipeID])
        ]) { error in
            completion(error == nil)
        }
    }

    func FavouriteRecipe(byUserID userID: String, recipeID: String, completion: @escaping (Bool) -> Void) {
        db.collection("Users").document(userID).getDocument { document, error in
            if let error = error {
                print("Error fetching user document: \(error.localizedDescription)")
                completion(false)
                return
            }

            guard let document = document, document.exists else {
                completion(false)
                return
            }

            if let favourites = document.data()?["favourites"] as? [String] {
                completion(favourites.contains(recipeID))
            } else {
                completion(false)
            }
        }
    }
}
