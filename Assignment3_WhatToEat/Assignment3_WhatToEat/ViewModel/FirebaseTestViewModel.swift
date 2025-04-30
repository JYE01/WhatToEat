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
    @Published var ingredients = [Ingredient]()
    
    func getIngredients() {
        db.collection("Ingredients").addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error getting notes: \(error)")
                return
            }
                    
            self.ingredients = snapshot?.documents.compactMap { document in
                try? document.data(as: Ingredient.self)
            } ?? []
        }
    }
}
