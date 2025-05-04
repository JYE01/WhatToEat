//
//  RecipeViewModel.swift
//  Assignment3_WhatToEat
//
//  Created by Felix on 4/5/2025.
//

import Foundation
import SwiftUI
import Combine

class RecipeViewModel: ObservableObject {
    // List of recipes that match the user's selected ingredients
    @Published var filteredRecipes: [Recipe] = []

    // All recipes fetched from Firestore
    private var allRecipes: [Recipe] = []

    // Retrieves the stored ingredients from UserDefaults (used for filtering)
    private var ingredientStorage: String {
        UserDefaults.standard.string(forKey: "ingredientStorage") ?? "[]"
    }
 
    // Firestore manager responsible for fetching recipes from the database
    private let firestoreManager = FirestoreManager()


    // ViewModel initializer that triggers the fetch of recipe data
    init() {
        fetchRecipes()
    }

    // Fetches recipes from Firestore and applies filtering based on stored ingredients
    func fetchRecipes() {
        firestoreManager.fetchRecipes { [weak self] recipes in
            DispatchQueue.main.async {
                // Store all fetched recipes
                self?.allRecipes = recipes
                // Filter based on current ingredients in UserDefaults
                self?.filterRecipes()
            }
        }
    }

    // Filters recipes to only include those that contain all of the selected ingredients
    private func filterRecipes() {
        // Decode selected ingredients from JSON string
        guard let data = ingredientStorage.data(using: .utf8),
              let selectedIngredients = try? JSONDecoder().decode([String].self, from: data) else {
            // If decoding fails, show all recipes
            self.filteredRecipes = allRecipes
            return
        }

        // Normalize selected ingredients (trim spaces and lowercase)
        let lowercasedIngredients = selectedIngredients.map {
            $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        }

        // Filter recipes that contain ALL of the selected ingredients
        self.filteredRecipes = allRecipes.filter { recipe in
            // Normalize recipe ingredients
            let recipeIngredients = recipe.ingredients.map {
                $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            }

            // Return true only if all selected ingredients exist in this recipe
            let matched = lowercasedIngredients.allSatisfy { ing in
                recipeIngredients.contains(ing)
            }
            return matched
        }
    }
}


