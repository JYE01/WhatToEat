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
               db.collection("Recipes").addSnapshotListener { snapshot, error in
                   if let error = error {
                       print("Error getting recipes: \(error)")
                       return
                   }

                   self.recipes = snapshot?.documents.compactMap { document in
                       try? document.data(as: Recipe.self)
                   } ?? []
               }
           }
}
