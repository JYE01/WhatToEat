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
    
    func addFavourite(forUserEmail email: String, recipeID: String, completion: @escaping (Bool) -> Void) {
        db.collection("Users")
            .whereField("email", isEqualTo: email)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching user document: \(error.localizedDescription)")
                    completion(false)
                    return
                }

                guard let document = snapshot?.documents.first else {
                    print("User with email \(email) not found.")
                    completion(false)
                    return
                }

                document.reference.updateData([
                    "favourites": FieldValue.arrayUnion([recipeID]) //add the recipe ID to the favourites array in firebase
                ]) { error in
                    completion(error == nil)
                }
            }
    }

    func removeFavourite(forUserEmail email: String, recipeID: String, completion: @escaping (Bool) -> Void) {
        db.collection("Users")
            .whereField("email", isEqualTo: email)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching user document: \(error.localizedDescription)")
                    completion(false)
                    return
                }

                guard let document = snapshot?.documents.first else {
                    print("User with email \(email) not found.")
                    completion(false)
                    return
                }

                document.reference.updateData([
                    "favourites": FieldValue.arrayRemove([recipeID])
                ]) { error in
                    completion(error == nil)
                }
            }
    }

    func isFavourite(forEmail email: String, recipeID: String, completion: @escaping (Bool) -> Void) {
        db.collection("Users")
            .whereField("email", isEqualTo: email)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching user document: \(error.localizedDescription)")
                    completion(false)
                    return
                }

                guard let document = snapshot?.documents.first else {
                    print("User with email \(email) not found.")
                    completion(false)
                    return
                }

                if let favourites = document.data()["favourites"] as? [String] {
                    completion(favourites.contains(recipeID))
                } else {
                    completion(false)
                }
            }
    }
    
    func fetchFavouriteRecipes(forEmail email: String, completion: @escaping ([Recipe]) -> Void) {
        db.collection("Users")
            .whereField("email", isEqualTo: email)
            .getDocuments { [self] snapshot, error in
                guard let document = snapshot?.documents.first else {
                    print("No user document found or error: \(error?.localizedDescription ?? "Unknown error")")
                    completion([])
                    return
                }

                guard let favouriteIDs = document.data()["favourites"] as? [String], !favouriteIDs.isEmpty else {
                    completion([])
                    return
                }
                
                print("Fetching recipes for IDs: \(favouriteIDs)") // this is the array for recipes ID in favourites array of user
                
                let recipeRefs = favouriteIDs.map { db.collection("Recipes").document($0) } //favourite ID will be mapped to document ID of Recipes collection
                var fetchedRecipes: [Recipe] = [] //will store the favourite recipe
                let group = DispatchGroup()

                for ref in recipeRefs {
                    group.enter() //start async task
                    ref.getDocument { document, error in
                        defer { group.leave() } //async task finishes

                        if let document = document, document.exists {
                            do {
                                let recipe = try document.data(as: Recipe.self)
                                fetchedRecipes.append(recipe)
                                print("Fetched recipe: \(recipe)")
                            } catch {
                                print("Decoding error for document ID \(document.documentID): \(error)")
                            }
                        } else {
                            print("No document found for ID: \(ref.documentID)")
                        }
                    }
                }

                group.notify(queue: .main) {
                    completion(fetchedRecipes)
                }
            }
    }
}
