//
//  RecipeViewModel.swift
//  Assignment3_WhatToEat
//
//  Created by Felix on 4/5/2025.
//
 
import Foundation
import SwiftUI
import Combine
 
// ViewModel responsible for managing and filtering recipes
class RecipeViewModel: ObservableObject {
    
    // Recipes matching user-selected ingredients
    @Published var filteredRecipes: [Recipe] = []
    
    // All recipes fetched from Firestore
    @Published var allRecipes: [Recipe] = []
    
    @Published var isDataReady: Bool = false
 
    // Stored JSON string of selected ingredients from AppStorage
    private var ingredientStorage: String {
        UserDefaults.standard.string(forKey: "ingredientStorage") ?? "[]"
    }
 
    // Firestore manager used to fetch recipe and user data
    private let firestoreManager = FirestoreManager()
 
    // Initialize and fetch recipes on creation
    init() {
        fetchRecipes()
    }
 
    // Fetch all recipes from Firestore, then apply initial filtering
    func fetchRecipes(completion: (() -> Void)? = nil) {
        firestoreManager.fetchRecipes { [weak self] recipes in
            DispatchQueue.main.async {
                self?.allRecipes = recipes
                self?.filterRecipes()
                self?.isDataReady = true
                completion?()
            }
        }
    }
 
    // Normalize an ingredient to its root form (basic singular form).
    // This helps match plural vs singular words (e.g. "carrots" vs "carrot").
    private func normalize(_ ingredient: String) -> String {
        var word = ingredient
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        // Special plural endings
        if word.hasSuffix("ies") {
            return String(word.dropLast(3)) + "y"  // berries → berry
        } else if word.hasSuffix("oes") || word.hasSuffix("ches") || word.hasSuffix("shes") || word.hasSuffix("xes") {
            return String(word.dropLast(2))        // tomatoes → tomato, dishes → dish
        } else if word.hasSuffix("es") {
            // only remove 'es' if the word ends in a known pattern
            let exceptions = ["noodles", "vegetables", "apples", "grapes", "candies", "berries"]
            if exceptions.contains(word) {
                return String(word.dropLast(1))  // noodles → noodle, apples → apple
            } else {
                return String(word.dropLast(2))  // buses → bus
            }
        } else if word.hasSuffix("s") && word.count > 3 {
            return String(word.dropLast(1))      // onions → onion
        }

        return word
    }


 
    // Filters recipes based on selected ingredients.
    // A recipe is included if at least one of the normalized selected ingredients
    // exists in the recipe's normalized ingredient list.
    func filterRecipes() {
        // Decode selected ingredients from JSON stored in AppStorage
        guard let data = ingredientStorage.data(using: .utf8),
                  let selectedIngredients = try? JSONDecoder().decode([String].self, from: data),
                  !selectedIngredients.isEmpty else {
                self.filteredRecipes = allRecipes
                return
        }
 
        // Normalize the selected ingredients to their base form
        let normalizedSelected = selectedIngredients.map(normalize)
 
        // Filter recipes that contain at least one of the selected ingredients
        self.filteredRecipes = allRecipes.filter { recipe in
                let normalizedRecipeIngredients = recipe.ingredients.map(normalize)
                return normalizedSelected.contains { normalizedRecipeIngredients.contains($0) }
        }
    }
 
    // Retrieves selected ingredients as an array from AppStorage JSON string
    var selectedIngredients: [String] {
        guard let data = ingredientStorage.data(using: .utf8),
              let decoded = try? JSONDecoder().decode([String].self, from: data) else {
            return []
        }
        return decoded
    }
 
    // Finds selected ingredients that are not used in any recipe, after normalizing both the recipe ingredients and user input.
    var unmatchedIngredients: [String] {
        // Normalize all recipe ingredients
        let allNormalizedIngredients = allRecipes
            .flatMap { $0.ingredients }
            .map(normalize)

        // Normalize user ingredients
        let normalizedUserIngredients = selectedIngredients.map(normalize)

        // Find unmatched ingredients by comparing normalized user input with normalized recipe data
        return normalizedUserIngredients.filter {
            !allNormalizedIngredients.contains($0)
        }
    }
}
 
